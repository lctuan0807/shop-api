module Comments
  class TreeSerializer
    def self.call(comment)
      {
        id: comment.id,
        content: comment.content,
        user_id: comment.user_id,
        created_at: comment.created_at,
        depth: comment.depth,
        left: comment.lft,
        right: comment.rgt,
        children: comment.children.map do |child|
          call(child)
        end
      }
    end
  end
end
