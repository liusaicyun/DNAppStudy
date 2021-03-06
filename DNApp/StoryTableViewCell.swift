//
//  StoryTableViewCell.swift
//  DNApp
//
//  Created by SaiCyun Liu on 2016-01-31.
//  Copyright © 2016年 SaiCyun Liu. All rights reserved.
//

import UIKit

protocol StoryTableViewCellDelegate: class {
    func storyTableViewCellDidTouchUpvote	(cell: StoryTableViewCell, sender: AnyObject)
    func storyTableViewCellDidTouchComment	(cell: StoryTableViewCell, sender: AnyObject)
}

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var badgeImageView:  UIImageView!
    @IBOutlet weak var titleLabel:      UILabel!
    @IBOutlet weak var timeLabel:       UILabel!
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel:     UILabel!
    @IBOutlet weak var upvoteButton:    SpringButton!
    @IBOutlet weak var commentButton:   SpringButton!
	@IBOutlet weak var commentTextView: AutoTextView!
			  weak var delegate:		StoryTableViewCellDelegate?
	
	@IBAction func upvoteButtonDidTouch(sender: AnyObject) {
        upvoteButton.animation  = "pop"
        upvoteButton.force      = 3
		upvoteButton.animate()

		delegate?.storyTableViewCellDidTouchUpvote(self, sender: sender)
	}

	@IBAction func commentButtonDidTouch(sender: AnyObject) {		// 这里的 sender 其实就是那个按钮对象
        commentButton.animation = "pop"
        commentButton.force     = 3
		commentButton.animate()

		delegate?.storyTableViewCellDidTouchComment(self, sender: sender)	// sender 是 commentButtonDidTouch 中的 sender，意思是完全转发出去
	}

	func configureWithStory(story: JSON) { //让 TableViewCell 的实例跟传入的 story 数据做映射。只要 story 符合 DataSource.  实际意思就是给个 JSON 格式的 story 映射到 cell 的所有元素
        let title                        = story["title"].string!
        let badge                        = story["badge"].string ?? ""
        let userDisplayname              = story["user_display_name"].string!
        let userPortraitUrl              = story["user_portrait_url"].string
        let	userJob                      = story["user_job"].string ?? ""
        let createdAt                    = story["created_at"].string!
        let voteCount                    = story["vote_count"].int!
        let commentCount                 = story["comment_count"].int!
        let comment                      = story["comment"].string ?? ""
//        let commentHTML                  = story["comment_html"].string ?? ""

        titleLabel.text                  = title
        badgeImageView.image             = UIImage(named: "badge-" + badge)
        avatarImageView.url              = userPortraitUrl?.toURL()
        avatarImageView.placeholderImage = UIImage(named: "content-avatar-default")
        authorLabel.text                 = userDisplayname + " " + userJob
        timeLabel.text                   = timeAgoSinceDate(dateFromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
		upvoteButton.setTitle(String(voteCount), forState: UIControlState.Normal)
		commentButton.setTitle(String(commentCount), forState: UIControlState.Normal)

        if let	commentTextView          = commentTextView {
				commentTextView.text     = comment
//        commentTextView.attributedText   = htmlToAttributedString(commentHTML + "<style>*{font-family:\"Avenir Next\";font-size:16px;line-height:20px}img{max-width:300px}</style>")
		}
		
		let storyId = story["id"].int!
		if LocalStore.isStoryUpvoted(storyId) {
			upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal) // 因为 Cell 是可重用的，所以 按钮的映射 颗粒度不能只针对到 cell, 应该针对到 story
			upvoteButton.setTitle(String(voteCount + 1),				forState: UIControlState.Normal)
		} else {
			upvoteButton.setImage(UIImage(named: "icon-upvote"),		forState: UIControlState.Normal)
			upvoteButton.setTitle(String(voteCount),					forState: UIControlState.Normal)
		}
	}


}
