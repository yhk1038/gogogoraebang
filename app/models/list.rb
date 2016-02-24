class List < ActiveRecord::Base
    
    belongs_to :feeling
    belongs_to :user
end
