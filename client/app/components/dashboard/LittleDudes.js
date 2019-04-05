import React from 'react';
import update from 'react/lib/update';
import Card from './Card';
import moment from 'moment';
import {DropTarget, DragDropContext} from 'react-dnd';
import ItemTypes from './ItemTypes';
import _ from 'lodash';
import HTML5Backend from 'react-dnd-html5-backend';
import store from 'store';

const cardTarget = {
  drop() {
  }
};

function _initializeResourcesStats(v5, data) {
  // For V5, we no longer display a chart, only the current
  // count, so add the expected data structure fields to allow
  // count cards to display
  if(v5) {
    return Object.keys(data).reduce(function(result, kind) {
      result[kind] = { total: data[kind].total, chart: []};
      return result;
    }, {});
  }

  const end = moment.utc(),
    start = moment().subtract(29, 'day'),
    days = [],
    kinds = ['user', 'group', 'host', 'layer', 'variable', 'webservice'],
    ret = {};

  let day = start;

  while (day <= end) {
    days.push(day.format('YYYY-MM-DD'));
    day = day.clone().add(1, 'day');
  }

  kinds.forEach((kind) => {
    let chart = days.map((label) => {
      return {label, value: 0};
    });

    const chartData = _.filter(data, (entry) => {
      return entry.kind === kind;
    });

    if (_.isArray(chartData)) {
      let prevValue = 0;

      chart = _.merge(_.keyBy(chart, 'label'), _.keyBy(chartData, 'label'));

      chart = _.chain(chart)
        .map((d) => d)
        .sortBy(['label'])
        .map((d) => {
          const value = window.parseFloat(d.value);

          if (value <= 0) {
            d.value = prevValue;
          } else {
            prevValue = d.value = value;
          }

          return d;
        })
        .takeRight(30)
        .value();
    }

    const total = _.last(chart).value;

    ret[kind] = {total, chart};
  });

  return ret;
};

class LittleDudes extends React.Component {
  static propTypes = {
    // connectDropTarget: PropTypes.func.isRequired
  }

  state = (() => {
    const cards = {
      Groups: {
        id: 1,
        title: 'Groups',
        total: 'group',
        routeTo: {to: 'groups'}
      },
      Users: {
        id: 2,
        title: 'Users',
        total: 'user',
        routeTo: {to: 'users'}
      },
      Layers: {
        id: 3,
        title: 'Layers',
        total: 'layer',
        routeTo: {to: 'layers'}
      },
      Hosts: {
        id: 4,
        title: 'Hosts',
        total: 'host',
        routeTo: {to: 'hosts'}
      },
      Services: {
        id: 5,
        title: 'Services',
        total: 'webservice',
        routeTo: {to: 'webservices'}
      },
      Secrets: {
        id: 6,
        title: 'Secrets',
        total: 'variable',
        routeTo: {to: 'secrets'}
      }
    };

    const order = ((defaultOrder, newOrder) => {
      return _.union(_.intersection(newOrder, defaultOrder), _.difference(defaultOrder, newOrder));
    })(
      Object.keys(cards),
      store.get(`config.${this.props.currentUser}.dashboardCardsOrder`) || []
    );

    const c = order.map((type, index) => {
      cards[type].id = index;
      return cards[type];
    });

    return {
      cards: c,
      data: _initializeResourcesStats(this.props.v5, this.props.data)
    };
  })();

  moveCard = (id, atIndex) => {
    const {card, index} = this.findCard(id),
      newState = update(this.state, {
        cards: {
          $splice: [
            [index, 1],
            [atIndex, 0, card]
          ]
        }
      }),
      order = newState.cards.map((e) => e.title);

    store.set(`config.${this.props.currentUser}.dashboardCardsOrder`, order)
    this.setState(newState);
  }

  findCard = (id) => {
    const {cards} = this.state,
      card = cards.filter((c) => c.id === id)[0];

    return {
      card,
      index: cards.indexOf(card)
    };
  }

  render() {
    const {connectDropTarget} = this.props,
      {cards} = this.state;
    const upperBound = _(this.state.data).map('chart').mapValues((v) => _(v).map('value').max()).values().max() || 0;
    const c = cards.map((card) => {
      return (
        <div className="col-lg-2 col-md-4 col-sm-6 col-xs-6"
             key={card.id}>
          <Card id={card.id}
                title={card.title}
                upperBound={upperBound}
                data={this.state.data}
                total={_.get(this.state.data[card.total], 'total') || 0}
                routeTo={card.routeTo}
                moveCard={this.moveCard}
                findCard={this.findCard}/>
        </div>
      );
    });

    return connectDropTarget(
      <div className="row">
        {c}
      </div>
    );
  }
}
;

export default DragDropContext(HTML5Backend)(
  DropTarget(ItemTypes.CARD, cardTarget, (connect) => ({
    connectDropTarget: connect.dropTarget()
  }))(LittleDudes)
);
