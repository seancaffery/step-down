
$(document).ready(function(){
  //filter("<100",$("#usages tr"));

  $("#use_filter").change(function(){
    filter(this.options[this.selectedIndex].value, 1, $("#usages tr"));
  });

  $("#scenario_filter").change(function(){
    filter(this.options[this.selectedIndex].value, 2, $("#usages tr"));
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
