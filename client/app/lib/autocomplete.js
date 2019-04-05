import $ from 'jquery';

export default (elem, availableOptions) => {

  const validateMember = (value) => {
    const isValid = availableOptions.map( (item) => { return item.value }).indexOf(value) === -1;
    $('.js-add-member-btn').prop('disabled', isValid);
  };

  $(elem)
  .autocomplete({
    source: availableOptions,
    autoFocus: true,
    select: ( event, ui ) => {
      validateMember(ui.item.value);
    }
  })
  .on('input', (e) => {
    validateMember(e.target.value);
  })
  .data("ui-autocomplete")._renderItem = (ul, item) => {
    return $( "<li>" )
      .data('ui-autocomplete-item', item )
      .append("<div class='autocomplete-entry icon icon-"+item.type+"'>"+ item.label +"</div>")
      .appendTo( ul );
  };
};
