require File.dirname(__FILE__) + '/lib/protectable'
require File.dirname(__FILE__) + '/lib/security_helper'
ActionController::Base.send(:include, Security::Protectable)
ActionView::Base.send(:include, Security::SecurityHelper)
ActionController::Base.send(:include, Security::SecurityHelper)