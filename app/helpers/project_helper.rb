module ProjectHelper
  def github_link(project)
    project.github_url ? link_to("#{project.github_url.split('/').last}", project.github_url, target: 'blank') : 'N/A'
  end
end
