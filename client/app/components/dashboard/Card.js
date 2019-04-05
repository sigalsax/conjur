import React from 'react';
import ItemTypes from './ItemTypes';
import {DragSource, DropTarget} from 'react-dnd';
import Chart from './Chart';
import moment from 'moment';
import $ from 'jquery';
import PropTypes from 'prop-types';

const titleToIcon = {
  Secrets: 'variable',
  Hosts: 'host',
  Users: 'user',
  Groups: 'group',
  Services: 'webservice',
  Layers: 'layer'
};

const titleToKind = {
  Secrets: 'variable',
  Hosts: 'host',
  Users: 'user',
  Groups: 'group',
  Services: 'webservice',
  Layers: 'layer'
};

const cardSource = {
  beginDrag(props) {
    return {
      id: props.id,
      originalIndex: props.findCard(props.id).index
    };
  },

  endDrag(props, monitor) {
    const {id: droppedId, originalIndex} = monitor.getItem(),
      didDrop = monitor.didDrop();

    if (!didDrop) {
      props.moveCard(droppedId, originalIndex);
    }
  }
};

const cardTarget = {
  canDrop() {
    return false;
  },

  hover(props, monitor) {
    const {id: draggedId} = monitor.getItem(),
      {id: overId} = props;

    if (draggedId !== overId) {
      const {index: overIndex} = props.findCard(overId);

      props.moveCard(draggedId, overIndex);
    }
  }
};

class Card extends React.Component {
  static propTypes = {
    connectDragSource: PropTypes.func.isRequired,
    connectDropTarget: PropTypes.func.isRequired,
    isDragging: PropTypes.bool.isRequired,
    id: PropTypes.any.isRequired,
    routeTo: PropTypes.object.isRequired,
    total: PropTypes.number.isRequired,
    upperBound: PropTypes.number.isRequired,
    title: PropTypes.string.isRequired,
    moveCard: PropTypes.func.isRequired,
    findCard: PropTypes.func.isRequired
  }

  state = {
    hoveredBarIndex: -1,
    tooltipStyle: {
      position: 'absolute',
      opacity: 0,
      pointerEvents: 'none',
      left: 0,
      width: 100,
      top: -70,
      height: 50
    }
  }

  chartOnMouseOver = (index, event) => {

    const newStyle = {};
    const containerWidth = $(event.target).closest(".counter-chart").width();
    if (index > 0) newStyle['left'] = `${containerWidth * (index + 0.5) / 30 - 50}px`;
    newStyle['opacity'] = (index === -1) ? 0 : 0.9;

    const tooltipStyle = this.createTooltipStyle(newStyle);

    this.setState({hoveredBarIndex: index, tooltipStyle});
  }

  createTooltipStyle(style) {
    return Object.assign({}, this.state.tooltipStyle, style);
  }

  renderToolTip() {
    const kind = titleToKind[this.props.title];
    const {data} = this.props;
    const resource = data[kind].chart[this.state.hoveredBarIndex] || {};
    const {tooltipStyle} = this.state;
    const resourceEl = [
      <div key="tip-header" className="tip-header">{resource.value}</div>,
      <div key="tip-content" className="tip-content">{moment(resource.label).format('MMMM DD')}</div>];

    return (
      <div className={`graph-tip graph-tip-${titleToIcon[this.props.title]}`} style={tooltipStyle}>
        {(this.state.hoveredBarIndex === -1) ? '' : resourceEl}
      </div>);
  }

  render() {
    const {connectDragSource, connectDropTarget, upperBound, data: _data} = this.props;
    const kind = titleToKind[this.props.title];
    const data = _data[kind].chart;

    return (connectDragSource || (r => r))((connectDropTarget || (r => r))(
      <div className="b-counters__item">
        <a className="b-counter well btn btn-default" href={`/ui/${this.props.routeTo.to}`} type="button" role="button">
          <p className="b-counter__title">
            <i className={`icon-${titleToIcon[this.props.title]}`}> {this.props.title}</i>
            <i className="icon-move dashboard-icon-move"/>
          </p>
          <p className={`b-counter__count icon-${titleToIcon[this.props.title]}-color`}>
            {this.props.total}
          </p>
          <div className="counter-chart">
            <Chart kind={kind} data={data} upperBound={upperBound} onMouseOver={this.chartOnMouseOver}/>
            {this.renderToolTip()}
          </div>
        </a>
      </div>
    ));
  }
}
;

export default DropTarget(ItemTypes.CARD, cardTarget, (connect) => ({
  connectDropTarget: connect.dropTarget()
}))(
  DragSource(ItemTypes.CARD, cardSource, (connect, monitor) => ({
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  }))(Card)
);
