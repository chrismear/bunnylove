# Copyright 2007, 2008, 2009, 2010, 2013 Chris Mear
# 
# This file is part of Bunnylove.
# 
# Bunnylove is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Bunnylove is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with Bunnylove.  If not, see <http://www.gnu.org/licenses/>.

Bunnylove::Application.routes.draw do
  resources :bunnies do
    post 'secret', :on => :new
    post 'check', :on => :member
  end
  resources :bunny_sessions
  resources :valentines do
    any 'received_after', :on => :collection
  end
  resources :frights do
    any 'received_after', :on => :collection
  end
  resources :password_resets do
    post 'secret', :on => :new
    post 'check', :on => :member
  end

  match '/' => 'misc#index', :as => :homepage
  match '/privacy' => 'misc#privacy', :as => :privacy
  match 'boom' => 'misc#boom', :as => :boom
  
  match '/bunnies/:bunny_id/valentines/received.:format' => 'valentines#received', :as => :received_bunny_valentines
  match '/bunnies/:bunny_id/frights/received.:format' => 'frights#received', :as => :received_bunny_frights
end
