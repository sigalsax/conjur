import React from 'react';
import cx from 'classnames';
import $ from 'jquery';
import ReactOnRails from 'react-on-rails';

const fetchSecret = (url) => {
  return new Promise((resolve, reject) => {
    $.get(url)
      .done(data => resolve(data))
      .fail(e => {
        if (e.status == 404 && e.responseJSON) {
          resolve(e.responseJSON);
        } else {
          reject(e.responseJSON || e.statusText);
        }
      });
  });
}

const saveSecret = (url, value) => {
  return new Promise((resolve, reject) => {
    $.post(url,{value})
      .done(data => resolve(data))
      .fail(e => reject(e.responseJSON || e.statusText));
  });
}

export default class SecretManager extends React.Component {
  state = {
    hidden: true,
    loading: false,
    secretValue: null,
    editSecretValue: '',
    error: null
  };

  fetchSecret = () => {
    if (this.state.loading || this.state.saving) return;
    this.setState({loading: true});

    fetchSecret(this.props.fetchURL)
      .then(({value, error}) => {
        if (!value) {
          return this.setState({
            loading: false,
            error
          })
        }

        this.setState({
          loading: false,
          secretValue: value,
          editSecretValue: value,
          error
        })
      })
      .catch(error => {
        this.setState({
          loading: false,
          error
        });
      });
  }

  toggleHide = () => {
    if (!this.state.secretValue) {
      this.fetchSecret();
    }
    this.setState({hidden: !this.state.hidden, editSecretValue: this.state.secretValue || ''});
  }

  saveSecret = () => {
    if (this.state.saving || this.state.loading) return;

    const secretValue = this.state.editSecretValue;

    this.setState({saving: true});

    saveSecret(this.props.editURL, secretValue)
      .then(({value}) => {
        this.setState({
          saving: false,
          secretValue: value,
          editSecretValue: value,
          error: null
        })
      })
      .catch(error => {
        this.setState({
          saving: false,
          error
        });
      });
  }

  renderError() {
    return !this.state.error ? null : (
        <div className='has-warning'>
          <span className="help-block">{this.state.error}</span>
        </div>
      );
  }

  renderSecret() {
    return this.state.hidden ? null :
      (<div className='box-body'
      >
        { this.renderError() }
        <textarea id='secret-value' name="secret-value" disabled={this.state.loading} className={cx('form-control', {loading: this.state.loading})} rows='2' value={this.state.editSecretValue} onChange={(e) => this.setState({editSecretValue: e.target.value})}/>
      </div>);
  }

  rotateSecret = () => {
    this.rotateForm.submit();
  }

  renderManager() {

    const RotateNow = this.props.hasRotator ?
      <button key={3} id='rotate-secret-value' type='button' className='btn btn-default' disabled={this.state.saving || this.state.loading} onClick={this.rotateSecret}
      >Rotate now
      </button>
      : undefined;

    const ToggleVisible = <button key={0} id='toggle-secret-visible' type='button' className='btn btn-default' onClick={this.toggleHide}>
      { this.state.hidden ? "View/Edit Secret Data" : "Hide Secret Data" }
    </button>;

    return (this.state.hidden ?
      [
        ToggleVisible,
        RotateNow
      ] :
      [
        ToggleVisible,
        <button key={1} type='button' className='btn btn-default'  onClick={this.fetchSecret} disabled={this.state.saving || this.state.loading}>
              <span
                className={cx('icon-spin3', {'animate-spin-before':this.state.loading})}>Refresh</span>
        </button>,
        <button key={2} id='save-secret-value' type='button' className='btn btn-default' disabled={this.state.saving || this.state.loading || this.state.secretValue == this.state.editSecretValue} onClick={this.saveSecret}
  >Save
    </button>,
        RotateNow
      ]).filter(b => b !== undefined);
  }
  render () {
    const csrfToken = ReactOnRails.authenticityToken();
    return (
      <div className='box secretVisible'>
        {
          this.props.hasRotator && <form ref={e => this.rotateForm = e} method="post" action={this.props.rotateURL} style={{display: "none"}}>
            <input type='hidden' name='authenticity_token' value={csrfToken} />
            <input type='hidden' name='expiration_enabled' value={this.props.expirationEnabled} />
            <input type="submit" />
          </form>
        }
        <div className='box-header with-border'>
          <h3 className='box-title'>
            Secret Manager
          </h3>
        </div>
        <div className='box-body'>
          <div role='toolbar' className='btn-toolbar'>
            {this.renderManager()}
          </div>
        </div>
        {this.renderSecret()}
      </div>);
  }
}
