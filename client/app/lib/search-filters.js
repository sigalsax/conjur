export default () => {
  $(document).ready(function(){

    $("#resource-filters input").on("change", function() {
      if ( $("#resource-filters input:checked").length >= 0 ) {
        $("#resource-filter-alert").fadeOut("fast");
        $("#new_search").submit();
      } else {
        $(this).prop('checked', true);
        $("#resource-filter-alert").fadeIn("fast").removeClass("hidden");
      };
    });

    $("#integration-filters input").on("change", function() {
      if ( $("#integration-filters input:checked").length >= 0 ) {
        $("#integration-filter-alert").fadeOut("fast");
        $("#new_search").submit();
      } else {
        $(this).prop('checked', true);
        $("#integration-filter-alert").fadeIn("fast").removeClass("hidden");
      };
    });

    $("#new_search").on("submit", function(event){
      event.preventDefault();
      $("*").css("cursor", "wait");
      $(".search-table tbody").fadeTo("fast", 0.35, function(){
        event.currentTarget.submit();
        $("#new_search").unbind("submit");
        $("#new_search").submit();
      });
    });

    $("#resource-filters .select-all").on("click", function() {
      $("#resource-filters input").prop("checked", true);
      $("#new_search").submit();
    });

    $("#resource-filters .deselect-all").on("click", function() {
      $("#resource-filters input").prop("checked", false);
    });

    $("#integration-filters .select-all").on("click", function() {
      $("#integration-filters input").prop("checked", true);
      $("#new_search").submit();
    });

    $("#integration-filters .deselect-all").on("click", function() {
      $("#integration-filters input").prop("checked", false);
    });
  });
}
