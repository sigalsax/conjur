import 'jquery-ui-css/core.css';
import 'jquery-ui-css/menu.css';
import 'jquery-ui-css/autocomplete.css';
import 'jquery-ui-css/theme.css';

import 'jquery-ujs';
import 'jquery-ui/autocomplete';

// register remove member confirmation dialog
import 'lib/remove-member-confirmation';

import ReactOnRails from 'react-on-rails';
import SecretManager from 'components/SecretManager';
import LittleDudes from 'components/dashboard/LittleDudes';
import DashboardActivityGraph from 'components/dashboard/ActivityGraph';
import createRoleGraph from 'lib/create-role-graph';
import getActivityData from 'utils/activity';
import ActivityGraph from 'lib/activity-graph';
import scrollTo from 'lib/page-scroller';
import searchFilters from 'lib/search-filters';
import sidebarToggle from 'lib/sidebar-toggle';
import tooltips from 'lib/tooltip';
import autoComplete from 'lib/autocomplete';
import 'jquery-ujs';

// This is how react_on_rails can see the HelloWorld in the browser.

// register components for ReactOnRails
ReactOnRails.register({
  LittleDudes,
  SecretManager,
  DashboardActivityGraph
});

window.conjur = {
  createRoleGraph,
  scrollTo,
  ActivityGraph,
  getActivityData,
  autoComplete
};

window.$ = $;
window.jQuery = $;

tooltips();
searchFilters();
sidebarToggle();
