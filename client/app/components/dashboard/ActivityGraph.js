// activity-chart.js --- component to show recent Conjur activity

import React from 'react';
// extend moment.js
import Moment from 'moment';
import { extendMoment } from 'moment-range';
import {Chart} from 'chart.js';
import _ from 'lodash';

const moment = extendMoment(Moment);

function _initializedashboardStats(data) {
  if (!_.isArray(data)) {
    return [];
  }

  const end = moment(),
    begin = _.min(data.map((d) => moment(d.date))),
    range = moment.range(begin, end),
    entries = _.groupBy(data, 'date'),
    result = [];

  for (let date of range.by('days')) {
    /* eslint-disable quote-props */
    const rows = entries[date.format('YYYY-MM-DD')],
      entry = {
        'success_logins': 0,
        'success_sudo': 0,
        'success_secrets_reads': 0,
        'success_secrets_updates': 0,
        'fail_sudo': 0,
        'fail_secrets_reads': 0,
        'fail_secrets_updates': 0,
        'fail_other': 0,
        date: date.toDate()
      };
    /* eslint-enable quote-props */
    if (rows) {
      const indexed = _.keyBy(rows, 'type');
      _.extend(entry, _.mapValues(indexed, _.property('value')));
    }
    result.push(entry);
  }

  return result.sort((a, b) => a.date - b.date);
}

class ActivityChart extends React.Component {
  state = {
    chart: null,
    stats: [
      {
        name: 'sudo',
        key: 'success_sudo',
        color: '#f0f0f0',
        border: '#ffffff'
      }, {
        name: 'secret reads',
        key: 'success_secrets_reads',
        color: '#9b59b6',
        border: '#9b59b6',
        hidden: true
      }, {
        name: 'secret read failures',
        key: 'fail_secrets_reads',
        color: '#ec2360',
        border: '#ec2360'
      }, {
        name: 'sudo failures',
        key: 'fail_sudo',
        color: '#fd9336',
        border: '#fd9336'
      }, {
        name: 'secret updates',
        key: 'success_secrets_updates',
        color: '#683c7a',
        border: '#683c7a'
      }, {
        name: 'secret update failures',
        key: 'fail_secrets_updates',
        color: '#a81945',
        border: '#a81945'
      }
    ]
  }

  componentDidUpdate() {
    this.drawChart();
  }

  componentDidMount() {
    this.drawChart();
  }

  drawChart() {
    const canvas = this.canvas,
      timeSeries = this.props.data.map((datum) => {
        return moment(datum.date).format('YY-MM-DD');
      }),
      ctx = canvas.getContext('2d'),
      chart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: timeSeries,
          datasets: this.state.stats.map((stat) => {
            return {
              label: stat.name,
              fill: false,
              hidden: stat.hidden,
              data: this.props.data.map((datum) => datum[stat.key]),
              backgroundColor: stat.border,
              borderColor: stat.border,
              pointBorderColor: stat.color,
              lineTension: 0.2
            };
          })
        },
        options: {
          scales: {
            yAxes: [{
              ticks: {
                beginAtZero: true
              }
            }]
          },
          legend: {
            display: false
            // position: 'bottom',
            // labels: {
            //     boxWidth: 15,
            //     fontColor: '#AAA'
            // }
          }
        }
      });
    this.chart = chart;
  }

  renderLegend() {
    const entries = this.state.stats.map((stat, index) => {
      const handleEntryClicked = () => {
          const newStats = this.state.stats.slice();
          const newStat = Object.assign({}, newStats[index]);
          newStat.hidden = !newStat.hidden;
          newStats[index] = newStat;

          this.setState({stats: newStats});
        },
        st = this.state.stats[index].hidden ? 'line-through' : 'none';
      return (
        <li key={`activity-graph-legend-${index}`} className="clickable" onClick={handleEntryClicked}>
          <span className="box" style={{backgroundColor: stat.border}}/>
          <span style={{textDecoration: st}}>
                        {stat.name}
                      </span>
        </li>
      );
    });
    return (
      <div className="legend">
        <ul>
          {entries}
        </ul>
      </div>
    );
  }

  render() {
    return (
      <div className="activity-chart">
        <canvas className="chart" ref={(n) => this.canvas = n} height="80%"/>
        {this.renderLegend()}
      </div>
    );
  }
}
;

export default class DashboardActivity extends React.Component {
  static defaultProps = {
    options: {
      maintainAspectRatio: false,
      legend: {
        'success_logins': 'Logins',
        'success_sudo': 'Sudo calls',
        'success_secrets_reads': 'Secret reads',
        'success_secrets_updates': 'Secret updates',
        'fail_sudo': 'Sudo failures',
        'fail_secrets_reads': 'Secret read failures',
        'fail_secrets_updates': 'Secret update failures',
        'fail_other': 'Other failures'
      },
      axis: {
        y: {
          label: 'Value'
        }
      }
    }
  };

  state = {data: _initializedashboardStats(this.props.data)};

  render() {
    return (
      <div className="box js-dashboard-activity">
        <div className="box-header">
          <h3 className="box-title">Activity</h3>
        </div>
        <div className="box-body">
          <div className="row">
            <div className="col-md-12">
              <div key="activity-graph">
                <ActivityChart options={this.props.options}
                               data={this.state.data}/>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
};
