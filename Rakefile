task :default => [:build]

PROJECT_DIR = File.dirname __FILE__
BOOTSTRAP_DIR = "#{PROJECT_DIR}/bootstrap"


task :grunt_boostrap do
	system "cd #{BOOTSTRAP_DIR} && grunt dist"
end

task :deploy_bootstrap do	
	rm_rf "#{PROJECT_DIR}/public/bootstrap"
	mkdir_p "#{PROJECT_DIR}/public/bootstrap"
	cp_r Dir.glob("#{BOOTSTRAP_DIR}/dist/*"), "#{PROJECT_DIR}/public/bootstrap"
end

task :build_bootstrap => [:grunt_boostrap, :deploy_bootstrap]

task :build => [:build_bootstrap]