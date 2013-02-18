class Series < ActiveRecord::Base
  extend FriendlyId
    

  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  attr_accessible :description, :ref_link, :slug, :title, :video_url
  friendly_id :title, :use => :slugged
  searchable do
    text :title
    text :organization
    text :tags
  end
    
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  
  
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :slug, :title
  
  
  
  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  def organization
    # future association
  end

  def tags
    # future association
  end
end