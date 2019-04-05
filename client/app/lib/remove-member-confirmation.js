import $ from 'jquery';

const createAllowAction = (originalAllowAction) => (link) => {
  const isRemoveMember = link.attr('data-confirm') && link.attr('data-confirm-type') === 'remove-member';
  if (!isRemoveMember) {
    return originalAllowAction(link);
  }
  showConfirmDialog(link);
  return false;
};

const confirmed = (link) => {
  link.removeAttr('data-confirm');
  return link.trigger('click.rails');
};

const showConfirmDialog = (link) => {
  const {type: toType, name: toName} = link.data('to-remove') || {};
  const {type: fromType, name: fromName} = link.data('from') || {};

  const html = `
  <div class="modal" id="delete-confirmation-modal">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <a class="close" data-dismiss="modal">×</a>
        </div>
        <div class="modal-body">
          <h4 nowrap>
            Are you sure you want to remove <span class='icon icon-${toType}'>${toName}</span> from<span class='icon icon-${fromType}'>${fromName}</span>?
          </h4>
        </div>
        <div class="modal-footer">
          <div class="pull-left">
            <a data-dismiss="modal" class="btn btn-primary confirm">Yes</a>
            <a data-dismiss="modal" class="btn btn-link btn-muted">Cancel</a>
          </div>
        </div>
      </div>
    </div>
  </div>
    `;

  $(html).modal();
  return $('#delete-confirmation-modal .confirm').on('click', () => {
    return confirmed(link);
  });
};

$.rails.allowAction = createAllowAction($.rails.allowAction);
