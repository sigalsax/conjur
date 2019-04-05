import React from 'react';
import cx from 'classnames';
import noop from 'utils/noop';

export default class TextInput extends React.Component {
  static defaultProps = {
    getText: noop,
    isValid: noop,
    updateText: noop,
    iconClass: ''
  }
  
  state = {
    visited: false
  }
  
  onChange = (e) => {
    const {path} = this.props;
    this.props.updateText({path, value: e.target.value});
    this.setVisited();
  }
  
  setVisited = () => {
    if (!this.state.visited) this.setState({visited: true});
  }
  
  render () {
    const {getText, path, isValid, iconClass, updateText:_, ...rest} = this.props;
    const {visited} = this.state;
    
    const value = getText(path);
    const hasError = !isValid(path) && visited;
    
    return (
      <div className={
        cx("form-group has-feedback",
        {
          'has-error': hasError
        })
      }>
        <input 
              {...rest}
              className="form-control"
              value={value}
              onBlur={this.setVisited}
              onChange={this.onChange}/>
        <span className={cx("form-control-feedback", {[iconClass]: iconClass})} />
      </div>);
  }
}
