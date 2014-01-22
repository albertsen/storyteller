namespace :db do
  
  LOREM_IPSUM=<<-EOF
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. 

Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
EOF
  
  def read_item(file)
    File.open file do |io|
      date = Date.strptime io.readline, "%d.%m.%Y"; io.readline
      title = io.readline; io.readline
      body = io.read
      [title, body, date]
    end    
  end
  
  task :"create-sections" do
    Section.create! :slug => "home", :name => "Home", :page_size => 0, :order => 10, :on_home_page => false, :in_navigation => true
    Section.create! :slug => "blog", :name => "Blog", :page_size => 20, :order => 20, :on_home_page => true, :in_navigation => true
    Section.create! :slug => "geschichten", :name => "Geschichten", :page_size => 20, :order => 30, :on_home_page => true, :in_navigation => true
    Section.create! :slug => "veroeffentlichungen", :name => "Veröffentlichungen", :page_size => 0, :order => 40, :on_home_page => true, :in_navigation => true
    Section.create! :slug => "links", :name => "Links", :page_size => 0, :order => 50, :on_home_page => false, :in_navigation => true
    Section.create! :slug => "uebermich", :name => "Über mich", :page_size => 0, :order => 60, :on_home_page => true, :in_navigation => true
    Section.create! :slug => "bait", :name => "Köder", :page_size => 0, :order => 70, :on_home_page => false, :in_navigation => false
  end
  
  task :"create-users" do
    User.create! :username => 'albertsen',
                 :password_salt => 'grQnmfHQ',
                 :password_hash => '3e2d22e843b55e9438e5011a47bc974a84aaa3c4a6dc98f0655ebe76bbe47800'
  end
  
  task :"create-stories" do
    time = 200.days.ago
    Dir["#{RAILS_ROOT}/db/import/*/*.txt"].each do |f|
      section_slug = File.dirname(f).split("/")[-1]
      section = Section.find_by_slug section_slug
      raise "No such secion: #{section_slug}" unless section
      puts "Importing #{f} into section #{section.slug}"
      title, body, date = read_item f
      Story.create! :title => title, :body => body, :created_at => date, :section => section
    end
  end
  
  task :"create-essentials" => [:environment, :"create-sections", :"create-users", :"create-stories"]

  task :"create-sample-blog-stories" do
    blog = Section.find_by_slug "blog"
    raise "Blog section not found" unless blog
    100.downto(1) do |i|
      puts "Creating BlogPost #{i}"
      Story.create! :title => i.to_s, :body => LOREM_IPSUM, :section => blog, :created_at => i.days.ago
    end
    Story.create! :body => LOREM_IPSUM, :section => blog, :created_at => Time.now
  end
  
  task :fill => [:"create-essentials", :"create-sample-blog-stories"]

  task :"extract-fixtures" => :environment do
    rm_f "#{RAILS_ROOT}/test/fixtures/*.yml"
    sql  = "SELECT * FROM %s"
    skip_tables = ["schema_migrations"]
    ActiveRecord::Base.establish_connection
    (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
      i = "000"
      File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w') do |file|
        data = ActiveRecord::Base.connection.select_all(sql % table_name)
        file.write data.inject({}) { |hash, record|
          fixture_name = record["slug"] || i.succ!
          hash[fixture_name] = record
          hash
        }.to_yaml
      end
    end
  end


  task :init => [:'db:drop', :'db:create', :'db:migrate', :'db:fill', :'db:extract-fixtures', :'db:test:clone_structure']

  
end