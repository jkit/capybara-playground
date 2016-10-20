require 'sinatra'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/simple' do
  erb <<-HTML, layout: :layout
    <h1>hello</h1>
  HTML
end

get '/hidden' do
  erb <<-HTML, layout: :layout
    <h1 class='hidden'>hello</h1>
  HTML
end

get '/delayed_hide' do
  erb <<-HTML, layout: :layout
    <h1>hello</h1>
    <script>
      $(function() {
        setTimeout(function() { $('h1').hide(); }, 500);
      });
    </script>
  HTML
end

get '/three_stages' do
  erb <<-HTML, layout: :layout
    <div id='container1'>
      <button id='first'>First</button>
    </div>
    <div id='container2'></div>
    <div id='container3'></div>

    <script>
      $(function() {
        var installSecond = function() {
          $('#container2').html("<button id='second'>Second</button>");
          $('#second').click(function() {
            setTimeout(installThird, 2000);
          });
        };

        var installThird = function() {
            $('#container3').html("<p>third</p>");
        };

        $('#first').click(installSecond);
      });
    </script>
  HTML
end

get '/delete' do
  erb <<-HTML, layout: :layout
    <button>Delete</button>
    <div id='content'>CONTENT</div>

    <script>
      $(function() {
        $('button').click(function() {
          setTimeout(function() { $('#content').remove(); }, 2000);
        });
      });
    </script>
  HTML
end

get '/text_input' do
  erb <<-HTML, layout: :layout
    <label for='name'>Full Name</label>
    <input type='text' id='name' />
    <a href='#' id='submit-link'>Submit</a>
    <p id='content'></p>

    <script>
      $(function() {
        $('#submit-link').click(function() {
          var name = $('#name').val();
          setTimeout(function() { $('#content').html('Hi ' + name); }, 1000);
        });
      });
    </script>
  HTML
end

get '/list' do
  erb <<-HTML, layout: :layout
    <ul id='list'></ul>

    <script>
      $(function() {
        for (var i = 0; i < 10; i++) {
          var parity = i % 2 === 0 ? 'even' : 'odd';
          $('#list').append("<li>" + parity + "</li>");
        }
      });
    </script>
  HTML
end

get '/slow_list' do
  erb <<-HTML, layout: :layout
    <ul id='list'></ul>

    <script>
      var addToList = function(value) {
        if (value < 0) { return; }
        var parity = value % 2 === 0 ? 'even' : 'odd';
        $('#list').append("<li>" + parity + "</li>");
        setTimeout(addToList, 250, value-1);
      };

      $(function() {
        addToList(10);
      });
    </script>
  HTML
end

get '/js_undefined_var' do
  erb <<-HTML, layout: :layout
    <script>
      thing
    </script>
  HTML
end

get '/js_undefined_onready' do
  erb <<-HTML, layout: :layout
    <script>
      $(function() {
        thing
      });
    </script>
  HTML
end

get '/js_syntax_error' do
  erb <<-HTML, layout: :layout
    <script>
      var =;
    </script>
  HTML
end
