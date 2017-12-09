
PROJECT_DIR = File.dirname __FILE__
BOOTSTRAP_DIR = "#{PROJECT_DIR}/bootstrap"
DOCKER_IMAGE_TAG = "storyteller:latest"


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

namespace :docker do

	task :build do
		system "docker build -t storyteller:latest ."
	end

	task :run do
		puts "Running Docker container"
		exec "docker run --name storyteller -p 3000:3000 -d #{DOCKER_IMAGE_TAG}"
	end

	task :stop do
		puts "Stopping Docker container"
		system "docker stop storyteller"
		puts "Removing Docker container"
		system "docker rm storyteller"
	end

	task :shell do
		exec "docker exec -t -i storyteller /bin/ash"
	end

	task :logs do
		exec "docker logs storyteller"
	end

end
