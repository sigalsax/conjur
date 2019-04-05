import d3 from 'd3';

import {forEach} from 'lodash';

var oneDay = 24*60*60*1000;

const getDefaultItem = _ => ({
  sread: 0,
  supdate: 0,
  fread: 0,
  fupdate: 0
});

export default (audit) => {
  var values = {},
    min,
    max;

  forEach(audit, (e) => {
    var date,
      type,
      value;

    if (typeof e.timestamp === 'string') {
      date = d3.time.hour(new Date(e.timestamp));
    }

    type = getEventType(e);

    if (date instanceof Date && typeof type === 'string') {
      value = values[date.toString()];

      if (typeof value === 'undefined') {
        value = getDefaultItem();
        value.date = date;
      }

      value[type] += 1;

      values[date.toString()] = value;

      if (typeof max === 'undefined') {
        max = date;
      }

      if (typeof min === 'undefined') {
        min = date;
      }

      if (date > max) {
        max = date;
      }

      if (date < min) {
        min = date;
      }
    }
  });

  var x = max - min;

  if (x < oneDay) {
    var delta = Math.round((86400000 - x) / 2);

    min = new Date(min.getTime() - delta);
    max = new Date(max.getTime() + delta);
  }

  return d3.time.scale()
    .domain([min, max])
    .ticks(d3.time.hours, 1)
    .map((date) => {
      var d = values[date.toString()] || getDefaultItem();

      d.date = date;

      return d;
    }).sort((a, b) => {
      return a.date - b.date;
    });
}

const getEventType = (e) => {
  var sf = getStatusKey(e.action);
  if (e.action.operation === 'fetch') {
    return sf + "read";
  } else if (e.action.operation === 'update') {
    return sf + "update";
  }

  return null;
}

const getStatusKey = (action) => {
  if(action == null ||
     action.result == null) {
    return null;
  }

  return action.result.charAt(0);
}