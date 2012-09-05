var usages = 11;
var unused = 11;
var empty = 11;
var grouping = 11;
$(document).ready(function(){

  $("#use_filter").change(function(){
    filter(this.options[this.selectedIndex].value, 1, $("#usages tr"));
  });

  $("#scenario_filter").change(function(){
    filter(this.options[this.selectedIndex].value, 2, $("#usages tr"));
  });

  $("a[class*=g]").click(function() {
    $('div.' + this.getAttribute("class")).toggle();
    $('.' + this.getAttribute("class") + ' tr').show();
    return false;
  });

  $('#usages tr').hide();
  $('#unused tr').hide();
  $('#empty tr').hide();
  $('#grouping tr').hide();

  $("#usages").next(".more").click(function(e){
    $('#usages tr:lt('+ usages +')').show();
    usages += 10;
    return false;
  });

  $("#unused").next(".more").click(function(e){
    $('#unused tr:lt('+ unused +')').show();
    unused += 10;
    return false;
  });

  $("#empty").next(".more").click(function(e){
    $('#empty tr:lt('+ empty +')').show();
    empty += 10;
    return false;
  });

  $("#grouping").next(".more").click(function(e){
    $('#grouping tr.grouping_row:lt('+ grouping +')').show();
    grouping += 10;
    return false;
  });

  $(".more").click();

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
