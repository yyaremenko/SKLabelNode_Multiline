extension SKLabelNode {
    func wrapIn(targetWidth: CGFloat, paragraphSpace: CGFloat? = nil) -> SKLabelNode {
        guard let text = text else {
            return self
        }

        let outputLabel = SKLabelNode()
        var subLabel = getSubLabel()
        
        var currentText = ""
        
        let parts = text.components(separatedBy: " ")
        
        var subLabels = [SKLabelNode]()
        
        for part in parts {
            subLabel = getSubLabel()
            
            let nextText = currentText + " " + part
            subLabel.text = nextText
            
            if subLabel.frame.width < targetWidth {
                currentText = nextText
                continue
            }
            
            // the whole word is out of boundaries - so we did not even have a chance
            // to write it to current text
            if currentText == "" {
                subLabel.text = part.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            } else {
                subLabel.text = currentText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                currentText = part // a MUST - as we did not write this 'exceeding' word to label
            }
            
            subLabels.append(subLabel)
        }
        
        if currentText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" {
            subLabel = getSubLabel()
            subLabel.text = currentText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            subLabels.append(subLabel)
        }
        
        // reposition lines relatively to center
        let spacing = paragraphSpace ?? fontSize / 2.5
        let numOfLines = CGFloat(subLabels.count)
        var currentY = (numOfLines * (fontSize + spacing)) / 2
        for label in subLabels {
            label.position.y = currentY
            currentY -= fontSize + spacing
            
            outputLabel.addChild(label)
        }

        return outputLabel
    }
    
    fileprivate func getSubLabel() -> SKLabelNode {
        let sub = SKLabelNode(fontNamed: fontName)
        sub.fontSize = fontSize
        sub.fontColor = fontColor
        
        sub.horizontalAlignmentMode = horizontalAlignmentMode
        sub.verticalAlignmentMode = verticalAlignmentMode
        
        sub.position = position
        
        return sub
    }
}