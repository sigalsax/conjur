import React from 'react';
import PropTypes from 'prop-types';
import d3 from 'd3';

import {BarChart} from '../charts';

const yScale = (upperBound) => (values, range) => {
  const maxValue = Math.ceil(upperBound || d3.max(values));

  return d3.scale.linear()
    .domain([0, maxValue])
    .range(range);
};

export default class Chart extends React.Component {

  static propTypes = {
    kind: PropTypes.string.isRequired,
    data: PropTypes.array.isRequired,
    upperBound: PropTypes.number.isRequired,
    onMouseOver: PropTypes.func
  };

  static defaultProps = {
    onMouseOver: () => {
    }
  };

  render() {
    const {kind, data} = this.props;
    return (
      <BarChart className={kind}
                parentHeight={2}
                parentWidth={9}
                data={data}
                xAxis={false}
                yAxis={false}
                yAxisType={yScale(this.props.upperBound)}
                onMouseOver={this.props.onMouseOver}
                margins={{top: 0, right: 0, bottom: 0, left: 0}}
                dataMargins={{top: 0, right: 0, bottom: 0, left: 0}}/>
    );
  }
};
