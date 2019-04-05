import React from 'react';
import PropTypes from 'prop-types';

export default class Bar extends React.Component {

  static propTypes = {
    index: PropTypes.number.isRequired,
    width: PropTypes.number.isRequired,
    height: PropTypes.number.isRequired,
    x: PropTypes.number.isRequired,
    y: PropTypes.number.isRequired,
    orient: PropTypes.oneOf(['left', 'top', 'right', 'bottom']),
    bg: PropTypes.bool,
    bgSize: PropTypes.number.isRequired,
    tooltip: PropTypes.string.isRequired,
    onMouseOver: PropTypes.func
  };

  static defaultProps = {
    orient: 'bottom',
    bg: true,
    onMouseOver: () => {
    }
  };

  /* eslint-disable no-unused-vars */
  getTooltip(tooltip) {
    // TBD - comment out tooltip for now since the data
    // in the dashboard is wrong/confusing
    // return (<title>{tooltip}</title>);

    return null;
  }

  /* eslint-enable no-unused-vars */

  render() {
    const {width, height, x, y, orient, bg, bgSize, index} = this.props;
    const tooltip = this.getTooltip(this.props.tooltip);

    let bgRect = null;

    if (bg) {
      let bgWidth, bgHeight, bgX, bgY;

      switch (orient) {
        case 'left':
          bgWidth = bgSize;
          bgHeight = height;
          bgX = x;
          bgY = y;
          break;

        case 'top':
          bgWidth = width;
          bgHeight = bgSize;
          bgX = x;
          bgY = 0;
          break;

        case 'right':
          bgWidth = bgSize;
          bgHeight = height;
          bgX = 0;
          bgY = y;
          break;

        case 'bottom':
          bgWidth = width;
          bgHeight = bgSize;
          bgX = x;
          bgY = 0;
          break;

        default:
          throw new Error(`Bar doesn't support orient='${orient}'`);
      }

      bgRect = (
        <rect className="chart-bar-data-series-bar-bg"
              width={bgWidth}
              height={bgHeight}
              x={bgX}
              y={bgY}>
          {tooltip}
        </rect>
      );
    }

    return (
      <g className="chart-bar-data-series-bar" onMouseOver={this.props.onMouseOver.bind(null, index)}
         onMouseOut={this.props.onMouseOver.bind(null, -1)}>
        {bgRect}
        <rect className="chart-bar-data-series-bar-data"
              width={width}
              height={height}
              x={x}
              y={y}>
          {tooltip}
        </rect>
      </g>
    );
  }
};
