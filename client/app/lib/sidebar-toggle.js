export default () => {
  const closeSidebar   = () => $('#sidebar').attr('class', 'sidebar-collapse')
  const openSidebar    = () => $('#sidebar').attr('class', 'sidebar-open')
  const toggleSidebar  = () => 
    $('#sidebar').toggleClass('sidebar-open sidebar-collapse')
  const toggleOnResize = () =>
    (window.innerWidth >= 768 ? openSidebar : closeSidebar)()

  $(document).ready(() => {
    $('.sidebar-toggle').on('click', toggleSidebar)
    window.addEventListener('resize', toggleOnResize)
  })
}
