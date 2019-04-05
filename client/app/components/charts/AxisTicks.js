import React from 'react';
import PropTypes from 'prop-types';
import _ from 'lodash';

export  default class AxisTicks extends React.Component {

  static propTypes = {
    scale: PropTypes.func.isRequired,
    orient: PropTypes.oneOf(['top', 'bottom', 'left', 'right']),
    ticks: PropTypes.array,
    ticksValues: PropTypes.array,
    tickFormat: PropTypes.func,
    innerTickSize: PropTypes.number,
    tickPadding: PropTypes.number,
    drawTicks: PropTypes.bool,
    drawTicksWithoutLabel: PropTypes.bool,
    drawLabels: PropTypes.bool
  }

  static defaultProps = {
    orient: 'left',
    ticks: [10],
    ticksValues: null,
    tickFormat: null,
    drawTicks: true,
    drawTicksWithoutLabel: false,
    drawLabels: true,
    innerTickSize: 6,
    tickPadding: 3
  }

  getTicks(scale) {
    const {ticks: _ticks, ticksValues} = this.props;

    if (_.isArray(ticksValues)) {
      return ticksValues;
    } else if (scale.ticks) {
      return scale.ticks(..._ticks);
    } else {
      return scale.domain();
    }
  }

  getTickFormat(scale) {
    const {ticks: _ticks, tickFormat: _tickFormat} = this.props;

    if (_.isFunction(_tickFormat)) {
      return _tickFormat;
    } else if (scale.tickFormat) {
      return scale.tickFormat(..._ticks);
    } else {
      return (d) => d;
    }
  }

  render() {
    let scale = this.props.scale.copy(),
      tickTransform, x1, y1, x2, y2, dy, textAnchor;

    const {innerTickSize, tickPadding, orient} = this.props,
      ticks = this.getTicks(scale),
      tickFormat = this.getTickFormat(scale),
      sign = orient === 'top' || orient === 'left' ? -1 : 1,
      tickSpacing = Math.max(innerTickSize, 0) + tickPadding;

    switch (orient) {
      case 'top':
      case 'bottom':
        tickTransform = (d) => `translate(${scale(d)}, 0)`;
        x1 = 'x';
        y1 = 'y';
        x2 = 'x2';
        y2 = 'y2';
        dy = sign < 0 ? '0em' : '.71em';
        textAnchor = 'middle';
        break;

      case 'left':
      case 'right':
        tickTransform = (d) => `translate(0, ${scale(d)})`;
        x1 = 'y';
        y1 = 'x';
        x2 = 'y2';
        y2 = 'x2';
        dy = '0.32em';
        textAnchor = sign < 0 ? 'end' : 'start';
        break;

      default:
        throw new Error(`AxisTicks doesn't support orient='${orient}'`);
    }

    if (scale.rangeBand) {
      const x = scale,
        dx = x.rangeBand() / 2;

      scale = (d) => x(d) + dx;
    }

    const {drawTicks, drawTicksWithoutLabel, drawLabels} = this.props;

    let gTicks;

    if (drawTicks || drawLabels) {
      gTicks = ticks.map((tick, idx) => {
        let tickC, labelC;
        const label = tickFormat(tick, scale);

        if (drawTicks && (drawTicksWithoutLabel || label)) {
          const lineProps = {};

          lineProps[y2] = sign * innerTickSize;
          lineProps[x2] = 0;

          tickC = <line {...lineProps} />;
        }

        if (drawLabels) {
          const textProps = {};

          textProps[y1] = sign * tickSpacing;
          textProps[x1] = 0;

          labelC = (
            <text textAnchor={textAnchor}
                  dy={dy}
                  {...textProps}>
              {label}
            </text>
          );
        }

        return (
          <g key={idx}
             className="chart-axis-tick"
             transform={tickTransform(tick)}>
            {tickC}
            {labelC}
          </g>
        );
      });
    }

    return (
      <g className="chart-axis-ticks">
        {gTicks}
      </g>
    );
  }
}
