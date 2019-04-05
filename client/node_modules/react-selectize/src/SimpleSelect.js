(function(){
  var ref$, all, any, drop, camelize, difference, filter, find, findIndex, last, map, reject, isEqualToObject, React, createFactory, div, img, span, ReactSelectize, toString$ = {}.toString;
  ref$ = require('prelude-ls'), all = ref$.all, any = ref$.any, drop = ref$.drop, camelize = ref$.camelize, difference = ref$.difference, filter = ref$.filter, find = ref$.find, findIndex = ref$.findIndex, last = ref$.last, map = ref$.map, reject = ref$.reject;
  isEqualToObject = require('prelude-extension').isEqualToObject;
  React = require('react'), createFactory = React.createFactory, ref$ = React.DOM, div = ref$.div, img = ref$.img, span = ref$.span;
  ReactSelectize = createFactory(require('./ReactSelectize'));
  module.exports = React.createClass({
    displayName: 'SimpleSelect',
    getDefaultProps: function(){
      return {
        filterOptions: curry$(function(options, search){
          var this$ = this;
          return filter(function(it){
            return it.label.toLowerCase().trim().indexOf(search.toLowerCase().trim()) > -1;
          })(
          options);
        }),
        onBlur: function(value, reason){},
        onFocus: function(value, reason){},
        placeholder: "",
        style: {},
        uid: function(it){
          return it.value;
        }
      };
    },
    render: function(){
      var ref$, search, value, values, onSearchChange, onValueChange, filteredOptions, options, autosize, disabled, dropdownDirection, groupId, groups, groupsAsColumns, renderGroupTitle, uid, this$ = this;
      ref$ = this.getComputedState(), search = ref$.search, value = ref$.value, values = ref$.values, onSearchChange = ref$.onSearchChange, onValueChange = ref$.onValueChange, filteredOptions = ref$.filteredOptions, options = ref$.options;
      ref$ = this.props, autosize = ref$.autosize, disabled = ref$.disabled, dropdownDirection = ref$.dropdownDirection, groupId = ref$.groupId, groups = ref$.groups, groupsAsColumns = ref$.groupsAsColumns, renderGroupTitle = ref$.renderGroupTitle, uid = ref$.uid;
      return ReactSelectize(import$({
        autosize: autosize,
        className: "simple-select" + (!!this.props.className ? " " + this.props.className : ""),
        disabled: disabled,
        dropdownDirection: dropdownDirection,
        groupId: groupId,
        groups: groups,
        groupsAsColumns: groupsAsColumns,
        renderGroupTitle: renderGroupTitle,
        uid: function(it){
          var uid;
          uid = this$.props.uid(it);
          return (search.length === 0) + "" + uid;
        },
        ref: 'select',
        anchor: last(values),
        onAnchorChange: function(arg$, callback){
          return callback();
        },
        open: this.state.open,
        onOpenChange: function(open, callback){
          if (!!open) {
            return this$.showOptions(callback);
          } else {
            return this$.setState({
              open: open
            }, callback);
          }
        },
        highlightedUid: this.state.highlightedUid,
        onHighlightedUidChange: function(highlightedUid, callback){
          return this$.setState({
            highlightedUid: highlightedUid
          }, callback);
        },
        firstOptionIndexToHighlight: function(){
          return this$.firstOptionIndexToHighlight(options, value);
        },
        options: options,
        renderOption: this.props.renderOption,
        renderNoResultsFound: this.props.renderNoResultsFound,
        search: search,
        onSearchChange: function(search, callback){
          return onSearchChange(search, callback);
        },
        values: values,
        onValuesChange: function(newValues, callback){
          var value;
          if (newValues.length === 0) {
            return onValueChange(undefined, function(){
              return this$.focus(callback);
            });
          } else {
            value = (function(){
              switch (false) {
              case newValues.length !== 1:
                return newValues[0];
              case !isEqualToObject(newValues[0], newValues[1]):
                return undefined;
              default:
                return newValues[1];
              }
            }());
            return function(){
              return function(callback){
                if (!!value) {
                  return onValueChange(value, callback);
                } else {
                  return callback();
                }
              };
            }()(function(){
              return this$.setState({
                open: false
              }, function(){
                this$.refs.select.blur();
                return callback();
              });
            });
          }
        },
        renderValue: function(item){
          var ref$;
          if (search.length > 0) {
            return null;
          } else {
            return ((ref$ = this$.props.renderValue) != null
              ? ref$
              : function(arg$){
                var label;
                label = arg$.label;
                return div({
                  className: 'simple-value'
                }, span(null, label));
              })(item);
          }
        },
        onBlur: function(arg$, reason){
          (function(){
            return function(callback){
              if (search.length > 0) {
                return onSearchChange("", callback);
              } else {
                return callback();
              }
            };
          })()(function(){
            return this$.props.onBlur(value, reason);
          });
        },
        onFocus: function(arg$, reason){
          this$.props.onFocus(value, reason);
        },
        placeholder: this.props.placeholder,
        style: this.props.style
      }, (function(){
        switch (false) {
        case typeof this.props.restoreOnBackspace !== 'function':
          return {
            restoreOnBackspace: this.props.restoreOnBackspace
          };
        default:
          return import$({}, (function(){
            switch (false) {
            case typeof this.props.renderNoResultsFound !== 'function':
              return {
                renderNoResultsFound: function(){
                  return this$.props.renderNoResultsFound(value, search);
                }
              };
            default:
              return {};
            }
          }.call(this)));
        }
      }.call(this))));
    },
    getComputedState: function(){
      var search, value, values, ref$, onSearchChange, onValueChange, optionsFromChildren, unfilteredOptions, filteredOptions, newOption, options, this$ = this;
      search = this.props.hasOwnProperty('search')
        ? this.props.search
        : this.state.search;
      value = this.props.hasOwnProperty('value')
        ? this.props.value
        : this.state.value;
      values = !!value
        ? [value]
        : [];
      ref$ = map(function(p){
        switch (false) {
        case !(this$.props.hasOwnProperty(p) && this$.props.hasOwnProperty(camelize("on-" + p + "-change"))):
          return this$.props[camelize("on-" + p + "-change")];
        case !(this$.props.hasOwnProperty(p) && !this$.props.hasOwnProperty(camelize("on-" + p + "-change"))):
          return function(arg$, callback){
            return callback();
          };
        case !(!this$.props.hasOwnProperty(p) && this$.props.hasOwnProperty(camelize("on-" + p + "-change"))):
          return function(o, callback){
            var ref$;
            return this$.setState((ref$ = {}, ref$[p + ""] = o, ref$), function(){
              return this$.props[camelize("on-" + p + "-change")](o, callback);
            });
          };
        case !(!this$.props.hasOwnProperty(p) && !this$.props.hasOwnProperty(camelize("on-" + p + "-change"))):
          return function(o, callback){
            var ref$;
            return this$.setState((ref$ = {}, ref$[p + ""] = o, ref$), callback);
          };
        }
      })(
      ['search', 'value']), onSearchChange = ref$[0], onValueChange = ref$[1];
      optionsFromChildren = (function(){
        var ref$;
        switch (false) {
        case !((ref$ = this.props) != null && ref$.children):
          return map(function(it){
            var ref$, value, children;
            if ((ref$ = it != null ? it.props : void 8) != null) {
              value = ref$.value, children = ref$.children;
            }
            return {
              label: children,
              value: value
            };
          })(
          toString$.call(this.props.children).slice(8, -1) === 'Array'
            ? this.props.children
            : [this.props.children]);
        default:
          return [];
        }
      }.call(this));
      unfilteredOptions = this.props.hasOwnProperty('options') ? (ref$ = this.props.options) != null
        ? ref$
        : [] : optionsFromChildren;
      filteredOptions = this.props.filterOptions(unfilteredOptions, search);
      newOption = typeof this.props.createFromSearch === 'function' ? this.props.createFromSearch(filteredOptions, search) : null;
      options = (!!newOption
        ? [(ref$ = import$({}, newOption), ref$.newOption = true, ref$)]
        : []).concat(filteredOptions);
      return {
        search: search,
        value: value,
        values: values,
        onSearchChange: onSearchChange,
        onValueChange: onValueChange,
        filteredOptions: filteredOptions,
        options: options
      };
    },
    getInitialState: function(){
      return {
        highlightedUid: undefined,
        open: false,
        search: "",
        value: undefined
      };
    },
    firstOptionIndexToHighlight: function(options, value){
      var index, ref$, this$ = this;
      index = !!value ? findIndex(function(it){
        return isEqualToObject(it, value);
      }, options) : undefined;
      switch (false) {
      case typeof index === 'undefined':
        return index;
      case options.length !== 1:
        return 0;
      case typeof ((ref$ = options[0]) != null ? ref$.newOption : void 8) !== 'undefined':
        return 0;
      default:
        if (all(function(it){
          return typeof it.selectable === 'boolean' && !it.selectable;
        })(
        drop(1)(
        options))) {
          return 0;
        } else {
          return 1;
        }
      }
    },
    focus: function(callback){
      this.refs.select.focus();
      return this.showOptions(callback);
    },
    highlightFirstSelectableOption: function(){
      var ref$, options, value;
      if (!this.state.open) {
        return;
      }
      ref$ = this.getComputedState(), options = ref$.options, value = ref$.value;
      this.refs.select.highlightAndScrollToSelectableOption(this.firstOptionIndexToHighlight(options, value), 1);
    },
    showOptions: function(callback){
      this.setState({
        open: (function(){
          switch (false) {
          case !this.props.disabled:
            return false;
          default:
            return true;
          }
        }.call(this))
      }, callback);
    },
    value: function(){
      if (this.props.hasOwnProperty('value')) {
        return this.props.value;
      } else {
        return this.state.value;
      }
    }
  });
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
