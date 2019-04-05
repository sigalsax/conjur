import React from 'react';
import PropTypes from 'prop-types';

export default class Chart extends React.Component {
  static propTypes = {
    children: PropTypes.node.isRequired,
    width: PropTypes.number.isRequired,
    height: PropTypes.number.isRequired
  };

  render() {
    const className = this.props.className;

    return (
      <svg className={`chart ${className}`}
           preserveAspectRatio="none"
           viewBox={`0 0 ${this.props.width} ${this.props.height}`}>
        {this.props.children}
      </svg>
    );
  }
}
