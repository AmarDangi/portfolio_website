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

  index do
    selectable_column
    id_column
    column :name
    column :bio
    column :photo do |about|
      if about.photo.attached?
        image_tag url_for(about.photo), size: "80x80"
      end
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :bio
      row :photo do |about|
        if about.photo.attached?
          image_tag url_for(about.photo), size: "150x150"
        end
      end
      row :resume do |about|
        if about.resume.attached?
          link_to about.resume.filename, url_for(about.resume), target: "_blank"
        end
      end
      row :created_at
      row :updated_at
    end
  end
end
