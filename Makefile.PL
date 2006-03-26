use 5.006;
use inc::Module::Install;

name            'Inline-Module';
all_from        'lib/Inline/Module.pm';

use_test_base;

requires        'Module::Compile' => '0.15';

clean_files     't/lib/*.pmc';

WriteAll;
