# -*- encoding : utf-8 -*-
class RademadeAdmin::FileController < RademadeAdmin::AbstractController

  def upload
    param_key = params[:column].to_sym
    uploader.store!(params[param_key])
    render :json => {
      :html => RademadeAdmin::Upload::PreviewService.new(uploader).preview_html,
      :file => uploader
    }
  rescue CarrierWave::UploadError => e
    show_error(e)
  end

  def gallery_upload
    gallery_service = RademadeAdmin::Gallery::Manager.new(params)
    gallery_service.upload_images
    render :json => {
      :gallery_images_html => gallery_service.gallery_images_html
    }
  rescue CarrierWave::UploadError => e
    show_error(e)
  end

  def gallery_remove
    gallery_service = RademadeAdmin::Gallery::Manager.new(params)
    gallery_service.remove_image
    render :json => { }
  rescue Exception => e
    show_error(e)
  end

  def crop
    image = uploader.crop_image(params[:path], params[:crop])
    uploader.store!(image)
    upload_preview_service = RademadeAdmin::Upload::PreviewService.new(uploader)
    render :json => {
      :html => upload_preview_service.preview_html,
      :file => uploader
    }
  rescue CarrierWave::UploadError => e
    show_error(e)
  end

  private

  def show_error(error)
    render :json => { :error => error.to_s }, :status => :unprocessable_entity
  end

  def uploader
    @uploader ||= RademadeAdmin::LoaderService.const_get(params[:uploader]).new(model, params[:column])
  end

  def model
    model_class = RademadeAdmin::LoaderService.const_get(params[:model])
    params[:saved].to_i.zero? ? model_class.new : model_class.find(params[:id])
  end

end