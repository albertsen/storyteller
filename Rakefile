PROJECT_DIR = File.dirname __FILE__
BOOTSTRAP_DIR = "#{PROJECT_DIR}/bootstrap"

namespace :bootstrap do
  task :grunt do
    system "cd #{BOOTSTRAP_DIR} && grunt dist"
  end

  task :deploy do
    rm_rf "#{PROJECT_DIR}/public/bootstrap"
    mkdir_p "#{PROJECT_DIR}/public/bootstrap"
    cp_r Dir.glob("#{BOOTSTRAP_DIR}/dist/*"), "#{PROJECT_DIR}/public/bootstrap"
  end

  task :build => [:grunt, :deploy]
end
