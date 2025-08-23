ActiveAdmin.register About do
    permit_params :name, :bio, :photo, :resume
  
    form do |f|
      f.inputs do
        f.input :name
        f.input :bio
        f.input :photo, as: :file
        f.input :resume, as: :file
      end
      f.actions
    end
  end
  
  # # app/admin/projects.rb
  # ActiveAdmin.register Project do
  #   permit_params :title, :description, :link, :image
  
  #   form do |f|
  #     f.inputs do
  #       f.input :title
  #       f.input :description
  #       f.input :link
  #       f.input :image, as: :file
  #     end
  #     f.actions
  #   end
  # end