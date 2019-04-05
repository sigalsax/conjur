import React from 'react';
import PropTypes from 'prop-types';

export default class AxisLine extends React.Component {

  static propTypes = {
    scale: PropTypes.func.isRequired,
    orient: PropTypes.oneOf(['left', 'top', 'right', 'bottom']),
    outerTickSize: PropTypes.number
  };

  static defaultProps = {
    orient: 'left',
    outerTickSize: 6
  };

  scaleExtent(domain) {
    const start = domain[0],
      stop = domain[domain.length - 1];

    return start < stop ? [start, stop] : [stop, start];
  }

  scaleRange(scale) {
    return scale.rangeExtent ? scale.rangeExtent() : this.scaleExtent(scale.range());
  }

  render() {
    const {orient, scale, outerTickSize} = this.props,
      sign = orient === 'top' || orient === 'left' ? -1 : 1,
      range = this.scaleRange(scale);

    let d;

    switch (orient) {
      case 'bottom':
      case 'top':
        d = `M${range[0]},${sign * outerTickSize}V0H${range[1]}V${sign * outerTickSize}`;
        break;

      case 'left':
      case 'right':
        d = `M${sign * outerTickSize},${range[0]}H0V${range[1]}H${sign * outerTickSize}`;
        break;

      default:
        throw new Error(`AxisLine doesn't support orient='${orient}'`);
    }

    return (
      <path d={d}/>
    );
  }
};
