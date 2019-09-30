"
I have the html page resources
"
Class {
	#name : #GraphQLBetaDemoHTML,
	#superclass : #Object,
	#category : #'GraphQLBeta-Demo'
}

{ #category : #'html sources' }
GraphQLBetaDemoHTML class >> exportHTMLFile: fileName [
	"Export the html content to the file name, in order to edit it"

	<script: 'self exportHTMLFile: ''foo.html'' '>
	| file s |
	file := fileName asFileReference.
	file exists
		ifTrue: [ file delete ].
	s := file writeStream.
	[ s nextPutAll: (self htmlPage copyReplaceAll: String cr with: String crlf) ]
		ensure: [ s close ].
	self inform: 'exported!!!'
]

{ #category : #dependencies }
GraphQLBetaDemoHTML class >> htmlPage [
	"DO NOT EDIT"
	^ '<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>GraphQL editor</title>
<meta name="description" content="GraphQL Editor - write and run your GraphQL code inside this page.">
<script>
  var protocol = ("https:" == document.location.protocol)? "https" : "http";
  document.write(unescape("%3Cscript src=\""+ protocol + "://code.jquery.com/jquery-1.11.0.min.js\" type=\"text/javascript\"%3E%3C/script%3E"));
  document.write(unescape("%3Cscript src=\""+ protocol + "://code.jquery.com/jquery-migrate-1.2.1.min.js\" type=\"text/javascript\"%3E%3C/script%3E"));
</script>
<link href="https://js.do/js/codemirror-5.32.1/lib/codemirror.css" rel="stylesheet">
<script src="https://js.do/js/codemirror-5.32.1/lib/codemirror.js"></script>
<style>
body{
  margin: 0;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 14px;
  line-height: 20px;
  color: #333333;
  background-color: #ffffff;
}
header {
  background-color: black;
  padding: 5px;
}
h1{
  color: white;
}
#gql_operation, #gql_variables{
  position: absolute;
}
#results_area, #gql_code{
  position: absolute;
  top: 120px;
  bottom: 60px;
}
#results_area{
  padding-left: 5px;
  right: 1em;
  left: 50%;
}
#gql_code, #gql_operation, #gql_variables{
  padding-right: 5px;
  right: 50%;
  left: 1em;
}
.beauty-input {

  -webkit-border-radius: 3px;
     -moz-border-radius: 3px;
          border-radius: 3px;

  background-color: #ffffff;
  border: 1px solid #cccccc;
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
     -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
          box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
  -webkit-transition: border linear 0.2s, box-shadow linear 0.2s;
     -moz-transition: border linear 0.2s, box-shadow linear 0.2s;
       -o-transition: border linear 0.2s, box-shadow linear 0.2s;
          transition: border linear 0.2s, box-shadow linear 0.2s;


}
.label {
  display: inline-block;
  padding: 2px 4px;
  font-size: 11.844px;
  font-weight: bold;
  line-height: 14px;
  color: #ffffff;
  text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25);
  white-space: nowrap;
  vertical-align: baseline;
  background-color: #999999;
  border-radius: 3px;
}
.top_label {
  z-index: 10;
  position: absolute;
  top: 0px;
  right: 10px;
  opacity: 0.5;
}
#col_resize{
  position: absolute;
  left: 50%;
  right: 50%;
  top: 140px;
  bottom: 60px;
  width: 10px;
  margin-left: -5px;
  cursor: col-resize;
  z-index: 3;
  text-align: center;
  vertical-align: middle;
  line-height: 50;
  color: #bbb;
  text-shadow: 1px 0px #ddd;
}

footer{
  position: absolute;
  text-align: center;
  bottom: 10px;
  left: 1em;
  right: 1em;
}
.buttons{
  margin-top: 20px;
  position: absolute;
  top: 69px;
  right: 1em;
  left: 1em;
}
.btn{
  display: inline-block;
  padding: 4px 12px;
  margin-bottom: 0;
  font-size: 14px;
  line-height: 20px;
  color: #333333;
  text-align: center;
  text-shadow: 0 1px 1px rgba(255, 255, 255, 0.75);
  vertical-align: middle;
  cursor: pointer;
  background-color: #f5f5f5;
  background-image: -moz-linear-gradient(top, #ffffff, #e6e6e6);
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#ffffff), to(#e6e6e6));
  background-image: -webkit-linear-gradient(top, #ffffff, #e6e6e6);
  background-image: -o-linear-gradient(top, #ffffff, #e6e6e6);
  background-image: linear-gradient(to bottom, #ffffff, #e6e6e6);
  background-repeat: repeat-x;
  border: 1px solid #bbbbbb;
  border-color: #e6e6e6 #e6e6e6 #bfbfbf;
  border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
  border-bottom-color: #a2a2a2;
  -webkit-border-radius: 4px;
  -moz-border-radius: 4px;
  border-radius: 4px;
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#ffffffff", endColorstr="#ffe6e6e6", GradientType=0);
  filter: progid:DXImageTransform.Microsoft.gradient(enabled=false);
  -webkit-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
  -moz-box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.2), 0 1px 2px rgba(0, 0, 0, 0.05);
}
.btn:hover {
  color: #333333;
  text-decoration: none;
  background-color: #e6e6e6;
  *background-color: #d9d9d9;
  /* Buttons in IE7 don"t get borders, so darken on hover */

  background-position: 0 -15px;
  -webkit-transition: background-position 0.1s linear;
     -moz-transition: background-position 0.1s linear;
       -o-transition: background-position 0.1s linear;
          transition: background-position 0.1s linear;
}
.btn:focus {
  outline: thin dotted #333;
  outline: 5px auto -webkit-focus-ring-color;
  outline-offset: -2px;
}
.btn.active,
.btn:active {
  background-color: #e6e6e6;
  background-color: #d9d9d9 \9;
  background-image: none;
  outline: 0;
  -webkit-box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
     -moz-box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
          box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.15), 0 1px 2px rgba(0, 0, 0, 0.05);
}
a{
  text-decoration: none;
}
.btn-small [class^="icon-"], .btn-small [class*=" icon-"] {
    margin-top: 0;
}
.btn-small{
  margin-top: 0;
  font-size: 11.9px;
  padding: 2px 10px;
  font-size: 11.9px;
  border-radius: 3px;
}
[class^="icon-"], [class*=" icon-"] {
  display: inline-block;
  width: 14px;
  height: 14px;
  margin-top: 1px;
  line-height: 14px;
  vertical-align: text-top;
  background-image: url(https://js.do/bootstrap/img/glyphicons-halflings.png);
  background-position: 14px 14px;
  background-repeat: no-repeat;
}
.icon-play {
  background-position: -264px -72px;
}
.icon-file {
  background-position: -24px -24px;
}
.icon-options{
  background-position: -264px 0;
}
.overlayer{
  position: absolute;
  z-index: 30;
  width: 100%;
  height: 100%;
  display: none;
}
.exampleOptions{
  padding: 5px;
  width: 100px;
  border: solid 1px gray;
  position: absolute;
  z-index: 40;
  background: white;
}
.exampleOptions a{
  display: block;
}
</style>

</head>
<body>
  <div class="overlayer">
    <div class="exampleOptions">
      <a href="javascript:;" onclick="example(this);return false;">Films</a>
      <a href="javascript:;" onclick="example(this);return false;">Heros</a>
      <a href="javascript:;" onclick="example(this);return false;">Operation</a>
    </div>
  </div>
  <header>
    <h1>ProtoGraphQL in Smalltalk</h1>
  </header>
  <form method="get" id="gql_form">
    <input id="query" name="query" type= "hidden">
    <input id="operation" name="operation" type= "hidden">
    <input id="variables" name="variables" type= "hidden">

    <div class="buttons">
      <a href="javascript:;" class="btn xbtn-info btn-small" onclick="run_code(); return false;">
        <i class="icon-play"></i>
        &nbsp; Run</a>
      <a href="javascript:;" class="btn xbtn-info btn-small" onclick="moreOptions(); return false;">
          <i class="icon-options"></i>
          &nbsp; Options</a>
      <a href="javascript:;" class="btn xbtn-info btn-small" onclick="showExamples(this); return false;">
        <i class="icon-file"></i>
        &nbsp; Examples
      </a>
      <label><input type="checkbox" id="shouldValidate" checked>Use validation</label>
    </div>

    <div id="gql_code">
      <span class="label top_label">GraphQL</span>
    </div>
    <div id="moreOptions">
      <div id="gql_operation">
        <span class="label top_label">Operation</span>
      </div>
      <div id="gql_variables">
        <span class="label top_label">Variables</span>
      </div>
    </div>
  </form>
  <div id="col_resize">||</div>
  <div id="results_area" class="code_area_result">
    <span class="label top_label">Result</span>
  </div>

  <footer>SemanTICs S.R.L.& Object Profile</footer>

  <script>
  var codeMirror, resultsMirror, operationMirror, variablesMirror;
  var examples = [];
  examples["Heros"]="{\n# You need to have the class Hero, https://github.com/OBJECTSEMANTICS/GraphQL\n  heros{\n    name\n    planet\n  }\n}\n";
  examples["Films"] = "{\n	allFilms{\n		name	\n	}\n}";
  examples["Operation"] = [`query operation1($name : String, $person : PersonInput, $gender : FilmType){
\tfilm(name:$name){
\t\tname
\t\trating
\t}
\tfilmsOn(gender: $gender){
\t\tname
\t\trating
\t}
\tfilmsDirected(by:$person){
\t\tname
\t}
}

query operation2 {
\thello
}`, "operation1", "{ \"name\":\"terminator\", \"person\":{name:\"George Lucas\"}, \"gender\":ACTION }"];

  $(function(){
    codeMirror = CodeMirror(document.getElementById("gql_code"),{
      "lineNumbers": true,
      "indentUnit": 0,
      "theme": "default",
      "smartIndent": false,
      "enterMode": "flat",
      "styleActiveLine": true,
      "autofocus": true
    });

    resultsMirror = createMirror("results_area");
    operationMirror = createMirror("gql_operation");
    variablesMirror = createMirror("gql_variables");

    $(".CodeMirror").addClass("beauty-input");

    window.onresize = function() {
      recalculate_windows_size();
    }
    window.onload = function() {
      recalculate_windows_size();
      resultsMirror.refresh();
    }
  });
  function createMirror(id){
    return CodeMirror(document.getElementById(id),{
      "lineNumbers": true,
      "indentUnit": 0,
      "theme": "default",
      "smartIndent": false,
      "enterMode": "flat",
      "styleActiveLine": true,
      "autofocus": false
    });
  }
  $(".overlayer").click(function(){ $(".overlayer").hide()});
  $("#col_resize").on("mousedown mouseup mouseover", function(event) {
    event.preventDefault();
    if (event.type == "mousedown") {
      var w = $(window).width();
      $(document).on("mousemove", function(event2) {
        var percent = (event2.pageX/w * 100);
        if (percent>95) {
          if (percent>97) { // if mouse out of browser, disable drag.
            disable_drag();
          }
          percent=95;
        } else if (percent < 5) {
          if (percent<3) { // if mouse out of browser, disable drag.
            disable_drag();
          }
          percent = 5;
        }
        $("#gql_code, #gql_operation, #gql_variables").css("right", (100-percent)+"%");
        $("#col_resize").css("right", (100-percent)+"%").css("left", (percent)+"%");
        $("#results_area").css("left", (percent)+"%");
      });
    } else if (event.type == "mouseup") {
      disable_drag();
    }
    function disable_drag() {
      $(document).off("mousemove");
    }
  });
  function recalculate_windows_size() {
    var h = document.getElementById("gql_code").clientHeight;
    $(".CodeMirror").height(h);
    var el = $("#moreOptions");
    if(el.css("display") == "none") return;
    $("#gql_code .CodeMirror").height(h * 0.59);
    $("#gql_operation").css({top: 120 + h * 0.61 });
    $("#gql_variables").css({top: 120 + h * 0.82 });
    $("#gql_operation .CodeMirror, #gql_variables .CodeMirror").height(h*0.18);
  }
  function example(id){
    var arr = examples[$(id).html()], x, y, z;
    if(typeof arr === "string"){
      x = arr;
      y = z = "";
    }else{
      if($("#moreOptions").css("display") == "none")
        moreOptions();
      x = arr[0];
      y = arr[1];
      z = arr[2];
    }
    codeMirror.setValue(x);
    operationMirror.setValue(y);
    variablesMirror.setValue(z);
    codeMirror.markClean();
    operationMirror.markClean();
    variablesMirror.markClean();
  }
  function showExamples(obj){
    $(".overlayer").show();
    var bb = $(obj).get(0).getBoundingClientRect();
    $(".exampleOptions").css({top: bb.y + bb.height, left: bb.x});
  }
  function moreOptions(){
    var el = $("#moreOptions");
    if(el.css("display") !== "none")
      el.hide();
    else el.show();
    recalculate_windows_size();
  }
  function run_code(){
    $("#query").val(codeMirror.getValue());
    $("#operation").val(operationMirror.getValue());
    $("#variables").val(variablesMirror.getValue());
    $.ajax({
      url:"",
      type:"POST",
      data:{
        query: codeMirror.getValue(),
        operationName: operationMirror.getValue(),
        variables: variablesMirror.getValue(),
        shouldValidate: $("#shouldValidate").prop("checked")
      },
      contentType:"application/json; charset=utf-8",
      success: function(data){
        resultsMirror.setValue(JSON.stringify(data,null,"\t"));
      },
      error: function(request, status, error){
        resultsMirror.setValue(request.responseText);
      }
    });
  }
  </script>
</html>
'
]

{ #category : #'html sources' }
GraphQLBetaDemoHTML class >> importHTMLFile: fileName [
	"Import the html from a file document, in order to save it in the smalltalk image"

	<script: 'self importHTMLFile: ''foo.html'' '>
	| content code |
	content := ((fileName asFileReference readStream contents copyReplaceAll: '''' with: '"')
		copyReplaceAll: String cr
		with: '') copyReplaceAll: String lf with: String cr.
	code := 'htmlPage
	"DO NOT EDIT"
	^ ''' , content , ''''.
	self class compile: code classified: 'dependencies'.
	self inform: 'Imported html!!!'
]
