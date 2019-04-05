export default (tag) => {
  const elem = $('.js-scroll-to[name="' + tag + '"]');
  $('html,body')
  .animate({
    scrollTop: elem.offset().top
  }, 2000);
};
