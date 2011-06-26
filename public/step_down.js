
$(document).ready(function(){

  $("#use_filter").change(function(){
    filter(this.options[this.selectedIndex].value, 1, $("#usages tr"));
  });

  $("#scenario_filter").change(function(){
    filter(this.options[this.selectedIndex].value, 2, $("#usages tr"));
  });

  $("a[class*=g]").click(function() {
    $('.' + this.getAttribute("class")).show();
    return false;
  });

  $(".more").click(function(e){
    link = $(this);
    partial = link.attr("partial");
    $.get('_' + partial + '.html',function(data){
      link.parents("tr").before(data);
      link.parents("tr").remove();
    }, 'html');
    return false;
  });

});


function filter(expression, column, rows){

  if(expression == "All"){
    $(rows).show();
    return;
  }

  for(var i = 1; i < rows.length; ++i)
    if (eval(rows[i].children[column].innerHTML + expression))
      $(rows[i]).hide();

}
