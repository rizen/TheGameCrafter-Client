use Test::More;
use Test::Deep;

use lib '../lib';
use 5.010;

use_ok 'TheGameCrafter::Client';

# get
is tgc_get('_test')->{method}, 'GET', 'get';

# error
eval { tgc_get('/api/something/that/does/not/exist') };
is $@->code, '404', 'error handling works';

# put
is tgc_put('_test', {foo => 'bar'})->{method}, 'PUT', 'put';

# delete 
is tgc_delete('_test', {foo => 'bar'})->{method}, 'DELETE', 'delete';

# post & upload
cmp_deeply 
    tgc_post('_test', { file => ['upload.txt']}),  
    {
          "params" => {
             "file" => "upload.txt"
          },    
          "env" => ignore(),
          "tracer" => ignore(),
          "uploads" => [
             {
                "filename" => "upload.txt",
                "type" => "text/plain",
                "size" => "13"
             }
          ],
          "method" => "POST",
          "path" => "/api/_test"
    },
    'post / upload';

done_testing();
