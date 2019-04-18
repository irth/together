module ApplicationHelper
  def auth_path(provider)
    "/auth/#{provider}"
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
