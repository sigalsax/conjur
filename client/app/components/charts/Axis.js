import React from 'react';
import PropTypes from 'prop-types';

import _ from 'lodash';

import AxisLine from './AxisLine';
import AxisTicks from './AxisTicks';

export default class Axis extends React.Component {
  static propTypes = {
    width: PropTypes.number.isRequired,
    height: PropTypes.number.isRequired,
    title: PropTypes.oneOf(['x', 'y']),
    drawLine: PropTypes.bool,
    drawTicks: PropTypes.bool,
    drawLabels: PropTypes.bool,
    scale: PropTypes.func.isRequired,
    orient: PropTypes.oneOf(['left', 'top', 'bottom', 'right']),
    ticks: PropTypes.array,
    ticksValues: PropTypes.array,
    innerTickSize: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    outerTickSize: PropTypes.number,
    tickPadding: PropTypes.number,
    tickFormat: PropTypes.func,
    mapping: PropTypes.object
  };

  static defaultProps = {
    orient: 'left',
    title: 'x',
    drawLine: true,
    drawTicks: true,
    drawLabels: true
  };

  renderAxisLine() {
    const {scale, orient, drawLine, outerTickSize} = this.props;

    if (drawLine) {
      return (
        <AxisLine scale={scale}
                  orient={orient}
                  outerTickSize={outerTickSize}/>
      );
    } else {
      return null;
    }
  }

  render() {
    const {width, height, orient} = this.props;
    let transform;

    switch (orient) {
      case 'left':
        transform = `translate(0, 0)`;
        break;

      case 'top':
        transform = `translate(0, 0)`;
        break;

      case 'right':
        transform = `translate(${width}, 0)`;
        break;

      case 'bottom':
        transform = `translate(0, ${height})`;
        break;

      default:
        throw new Error(`Axis doesn't support orient='${orient}'`);
    }

    const {
      scale,
      ticks,
      ticksValues,
      tickPadding,
      title,
      drawTicks,
      drawLabels,
      mapping
    } = this.props;

    let {innerTickSize} = this.props;

    if (_.isString(innerTickSize)) {
      innerTickSize = parseFloat(innerTickSize) / 100 *
        (orient === 'top' || orient === 'bottom' ? height : width);
    }

    let {tickFormat} = this.props;

    if (!_.isFunction(tickFormat) && _.isObject(mapping)) {
      tickFormat = (d) => mapping[d];
    }

    return (
      <g className={`chart-${title}-axis`} transform={transform}>
        <AxisTicks scale={scale}
                   orient={orient}
                   ticks={ticks}
                   ticksValues={ticksValues}
                   tickFormat={tickFormat}
                   innerTickSize={innerTickSize}
                   tickPadding={tickPadding}
                   drawTicks={drawTicks}
                   drawLabels={drawLabels}
                   height={height}/>
        {this.renderAxisLine()}
      </g>
    );
  }
};
