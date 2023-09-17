import UIKit
import CoreData
class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var folderIcon: UIImageView!
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var noteNumber: UILabel!

    private var observation: NSObjectProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
