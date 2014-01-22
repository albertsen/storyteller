ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.

  root_section = Section.find_by_path "/"
  if root_section
    map.root :controller => "sections", :action => "show", :slug => root_section.slug
  end

  map.connect "items/add_comment/:id", :controller => "items", :action => "add_comment"
  map.invisible_items "items/invisible", :controller => "items", :action => "invisible"
  map.resources :items  
  map.resources :media  
  map.item_with_slug "items/:id/:slug", :controller => "items", :action => "show"
  
  if ActiveRecord::Base.connection.tables.include? "sections"
    Section.all.each do |section|
      map.named_route section.slug, "#{section.slug}", {:controller => "sections", :action => "show", :slug => section.slug}
      map.connect "#{section.slug}.:format", {:controller => "sections", :action => "show", :slug => section.slug}
    end
  else
    puts "WARNING: No sections found to generate routes from"
  end

  map.search "search", :controller => "search", :action => "search"
  map.login "login", :controller => 'account', :action => "login"
  map.logout "logout", :controller => "account", :action => "logout"
  map.feed "feed", :controller => "feed", :action => "index", :format => "rss"
  map.contact "kontakt", :controller => "contact", :action => "contact"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
