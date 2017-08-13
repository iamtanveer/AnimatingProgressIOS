
import UIKit

@IBDesignable
class CustomView: UIView, CAAnimationDelegate {
	
	var updateLayerValueForCompletedAnimation : Bool = false
	var animationAdded : Bool = false
	var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
	var layers : Dictionary<String, AnyObject> = [:]
	
	var grayColor : UIColor!
	var progressColor : UIColor!
	var finishColor : UIColor!
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupProperties()
		setupLayers()
	}
	
	var oldAnimProgress: CGFloat = 0{
		didSet{
			if(!self.animationAdded){
				removeAllAnimations()
				addOldAnimation()
				self.animationAdded = true
				layer.speed = 0
				layer.timeOffset = 0
			}
			else{
				let totalDuration : CGFloat = 1.86
				let offset = oldAnimProgress * totalDuration
				layer.timeOffset = CFTimeInterval(offset)
			}
		}
	}
	
	override var frame: CGRect{
		didSet{
			setupLayerFrames()
		}
	}
	
	override var bounds: CGRect{
		didSet{
			setupLayerFrames()
		}
	}
	
	func setupProperties(){
		self.grayColor = UIColor(red:0.831, green: 0.831, blue:0.831, alpha:1)
		self.progressColor = UIColor(red:0.176, green: 0.408, blue:0.996, alpha:1)
		self.finishColor = UIColor(red:0.298, green: 0.843, blue:0.267, alpha:1)
	}
	
	func setupLayers(){
		let path = CAShapeLayer()
		self.layer.addSublayer(path)
		path.isHidden    = true
		path.fillColor   = nil
		path.strokeColor = UIColor(red:0.831, green: 0.831, blue:0.831, alpha:1).cgColor
		path.lineWidth   = 15
		layers["path"] = path
		
		let oval = CAShapeLayer()
		self.layer.addSublayer(oval)
		oval.fillColor   = nil
		oval.strokeColor = self.grayColor.cgColor
		oval.lineWidth   = 24
		layers["oval"] = oval
		
		let oval2 = CAShapeLayer()
		self.layer.addSublayer(oval2)
		oval2.lineCap     = kCALineCapRound
		oval2.lineJoin    = kCALineJoinRound
		oval2.fillColor   = nil
		oval2.strokeColor = self.progressColor.cgColor
		oval2.lineWidth   = 24
		oval2.strokeStart = 1
		oval2.strokeEnd   = 0.99
		layers["oval2"] = oval2
		
		let path2 = CAShapeLayer()
		self.layer.addSublayer(path2)
		path2.lineCap     = kCALineCapRound
		path2.lineJoin    = kCALineJoinRound
		path2.fillColor   = nil
		path2.strokeColor = self.grayColor.cgColor
		path2.lineWidth   = 15
		layers["path2"] = path2
		
		let path3 = CAShapeLayer()
		self.layer.addSublayer(path3)
		path3.isHidden    = true
		path3.setValue(-180 * CGFloat.pi/180, forKeyPath:"transform.rotation")
		path3.lineCap     = kCALineCapRound
		path3.lineJoin    = kCALineJoinRound
		path3.fillColor   = nil
		path3.strokeColor = self.progressColor.cgColor
		path3.lineWidth   = 15
		layers["path3"] = path3
		
		let text = CATextLayer()
		self.layer.addSublayer(text)
		text.isHidden        = true
		text.contentsScale   = UIScreen.main.scale
		text.string          = "Completed\n"
		text.font            = "HelveticaNeue-Medium" as CFTypeRef
		text.fontSize        = 39
		text.alignmentMode   = kCAAlignmentCenter;
		text.foregroundColor = self.finishColor.cgColor
		layers["text"] = text
		setupLayerFrames()
	}
	
	func setupLayerFrames(){
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		if let path : CAShapeLayer = layers["path"] as? CAShapeLayer{
			path.frame = CGRect(x: 0.46751 * path.superlayer!.bounds.width, y: 0.71402 * path.superlayer!.bounds.height, width: 0.24953 * path.superlayer!.bounds.width, height: 0.17552 * path.superlayer!.bounds.height)
			path.path  = pathPath(bounds: (layers["path"] as! CAShapeLayer).bounds).cgPath
		}
		
		if let oval : CAShapeLayer = layers["oval"] as? CAShapeLayer{
			oval.frame = CGRect(x: 0.1506 * oval.superlayer!.bounds.width, y: 0.06658 * oval.superlayer!.bounds.height, width: 0.6988 * oval.superlayer!.bounds.width, height: 0.6988 * oval.superlayer!.bounds.height)
			oval.path  = ovalPath(bounds: (layers["oval"] as! CAShapeLayer).bounds).cgPath
		}
		
		if let oval2 : CAShapeLayer = layers["oval2"] as? CAShapeLayer{
			oval2.frame = CGRect(x: 0.1506 * oval2.superlayer!.bounds.width, y: 0.06658 * oval2.superlayer!.bounds.height, width: 0.6988 * oval2.superlayer!.bounds.width, height: 0.6988 * oval2.superlayer!.bounds.height)
			oval2.path  = oval2Path(bounds: (layers["oval2"] as! CAShapeLayer).bounds).cgPath
		}
		
		if let path2 : CAShapeLayer = layers["path2"] as? CAShapeLayer{
			path2.frame = CGRect(x: 0.37815 * path2.superlayer!.bounds.width, y: 0.3564 * path2.superlayer!.bounds.height, width: 0.2437 * path2.superlayer!.bounds.width, height: 0.11917 * path2.superlayer!.bounds.height)
			path2.path  = path2Path(bounds: (layers["path2"] as! CAShapeLayer).bounds).cgPath
		}
		
		if let path3 : CAShapeLayer = layers["path3"] as? CAShapeLayer{
			path3.transform = CATransform3DIdentity
			path3.frame     = CGRect(x: 0.37815 * path3.superlayer!.bounds.width, y: 0.35839 * path3.superlayer!.bounds.height, width: 0.2437 * path3.superlayer!.bounds.width, height: 0.11718 * path3.superlayer!.bounds.height)
			path3.setValue(-180 * CGFloat.pi/180, forKeyPath:"transform.rotation")
			path3.path      = path3Path(bounds: (layers["path3"] as! CAShapeLayer).bounds).cgPath
		}
		
		if let text : CATextLayer = layers["text"] as? CATextLayer{
			text.frame = CGRect(x: 0.11917 * text.superlayer!.bounds.width, y: 0.80473 * text.superlayer!.bounds.height, width: 0.76167 * text.superlayer!.bounds.width, height: 0.21915 * text.superlayer!.bounds.height)
		}
		
		CATransaction.commit()
	}
	
	//MARK: - Animation Setup
	
	func addOldAnimation(reverseAnimation: Bool = false, completionBlock: ((_ finished: Bool) -> Void)? = nil){
		if completionBlock != nil{
			let completionAnim = CABasicAnimation(keyPath:"completionAnim")
			completionAnim.duration = 1.858
			completionAnim.delegate = self
			completionAnim.setValue("old", forKey:"animId")
			completionAnim.setValue(false, forKey:"needEndAnim")
			layer.add(completionAnim, forKey:"old")
			if let anim = layer.animation(forKey: "old"){
				completionBlocks[anim] = completionBlock
			}
		}
		
		self.layer.speed = 1
		self.animationAdded = false
		
		let fillMode : String = reverseAnimation ? kCAFillModeBoth : kCAFillModeForwards
		
		let totalDuration : CFTimeInterval = 1.858
		
		let path = layers["path"] as! CAShapeLayer
		
		////Path animation
		let pathTransformAnim       = CABasicAnimation(keyPath:"transform.rotation")
		pathTransformAnim.fromValue = 0;
		pathTransformAnim.toValue   = 360 * CGFloat.pi/180;
		pathTransformAnim.duration  = 1.46
		
		let pathStrokeColorAnim      = CAKeyframeAnimation(keyPath:"strokeColor")
		pathStrokeColorAnim.values   = [self.grayColor.cgColor, 
			 self.progressColor.cgColor, 
			 self.progressColor.cgColor]
		pathStrokeColorAnim.keyTimes = [0, 0.0699, 1]
		pathStrokeColorAnim.duration = 1.46
		
		var pathOldAnim : CAAnimationGroup = QCMethod.group(animations: [pathTransformAnim, pathStrokeColorAnim], fillMode:fillMode)
		if (reverseAnimation){ pathOldAnim = QCMethod.reverseAnimation(anim: pathOldAnim, totalDuration:totalDuration) as! CAAnimationGroup}
		path.add(pathOldAnim, forKey:"pathOldAnim")
		
		////Oval2 animation
		let oval2StrokeStartAnim       = CABasicAnimation(keyPath:"strokeStart")
		oval2StrokeStartAnim.fromValue = 1;
		oval2StrokeStartAnim.toValue   = 0;
		oval2StrokeStartAnim.duration  = 1.46
		
		let oval2StrokeColorAnim       = CABasicAnimation(keyPath:"strokeColor")
		oval2StrokeColorAnim.fromValue = UIColor(red:0.176, green: 0.408, blue:0.996, alpha:1).cgColor;
		oval2StrokeColorAnim.toValue   = self.finishColor.cgColor;
		oval2StrokeColorAnim.duration  = 0.077
		oval2StrokeColorAnim.beginTime = 1.68
		
		var oval2OldAnim : CAAnimationGroup = QCMethod.group(animations: [oval2StrokeStartAnim, oval2StrokeColorAnim], fillMode:fillMode)
		if (reverseAnimation){ oval2OldAnim = QCMethod.reverseAnimation(anim: oval2OldAnim, totalDuration:totalDuration) as! CAAnimationGroup}
		layers["oval2"]?.add(oval2OldAnim, forKey:"oval2OldAnim")
		
		let path2 = layers["path2"] as! CAShapeLayer
		
		////Path2 animation
		let path2TransformAnim      = CAKeyframeAnimation(keyPath:"transform.rotation.z")
		path2TransformAnim.values   = [0, 
			 360 * CGFloat.pi/180]
		path2TransformAnim.keyTimes = [0, 1]
		path2TransformAnim.duration = 1.46
		
		let path2StrokeColorAnim      = CAKeyframeAnimation(keyPath:"strokeColor")
		path2StrokeColorAnim.values   = [self.grayColor.cgColor, 
			 self.progressColor.cgColor, 
			 self.progressColor.cgColor]
		path2StrokeColorAnim.keyTimes = [0, 0.0699, 1]
		path2StrokeColorAnim.duration = 1.46
		
		let path2HiddenAnim       = CABasicAnimation(keyPath:"hidden")
		path2HiddenAnim.fromValue = true;
		path2HiddenAnim.toValue   = true;
		path2HiddenAnim.duration  = 0.107
		path2HiddenAnim.beginTime = 1.46
		
		var path2OldAnim : CAAnimationGroup = QCMethod.group(animations: [path2TransformAnim, path2StrokeColorAnim, path2HiddenAnim], fillMode:fillMode)
		if (reverseAnimation){ path2OldAnim = QCMethod.reverseAnimation(anim: path2OldAnim, totalDuration:totalDuration) as! CAAnimationGroup}
		path2.add(path2OldAnim, forKey:"path2OldAnim")
		
		let path3 = layers["path3"] as! CAShapeLayer
		
		////Path3 animation
		let path3TransformAnim            = CAKeyframeAnimation(keyPath:"transform")
		path3TransformAnim.values         = [NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, -1)), 
			 NSValue(caTransform3D: CATransform3DMakeRotation(1 * CGFloat.pi/180, 0, 0, -1)), 
			 NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1)), 
			 NSValue(caTransform3D: CATransform3DIdentity)]
		path3TransformAnim.keyTimes       = [0, 0.461, 0.814, 1]
		path3TransformAnim.duration       = 0.413
		path3TransformAnim.beginTime      = 1.45
		path3TransformAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
		
		let path3HiddenAnim       = CABasicAnimation(keyPath:"hidden")
		path3HiddenAnim.fromValue = false;
		path3HiddenAnim.toValue   = false;
		path3HiddenAnim.duration  = 0.377
		path3HiddenAnim.beginTime = 1.45
		
		let path3PathAnim            = CABasicAnimation(keyPath:"path")
		path3PathAnim.fromValue      = QCMethod.alignToBottomPath(path: path3Path(bounds: (layers["path3"] as! CAShapeLayer).bounds), layer:layers["path3"] as! CALayer).cgPath;
		path3PathAnim.toValue        = QCMethod.alignToBottomPath(path: pathPath(bounds: (layers["path"] as! CAShapeLayer).bounds), layer:layers["path3"] as! CALayer).cgPath;
		path3PathAnim.duration       = 0.077
		path3PathAnim.beginTime      = 1.68
		path3PathAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
		
		let path3PositionAnim            = CABasicAnimation(keyPath:"position")
		path3PositionAnim.fromValue      = NSValue(cgPoint: CGPoint(x: 0.5 * path3.superlayer!.bounds.width, y: 0.41698 * path3.superlayer!.bounds.height));
		path3PositionAnim.toValue        = NSValue(cgPoint: CGPoint(x: 0.49667 * path3.superlayer!.bounds.width, y: 0.46 * path3.superlayer!.bounds.height));
		path3PositionAnim.duration       = 0.0585
		path3PositionAnim.beginTime      = 1.68
		path3PositionAnim.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
		
		let path3StrokeColorAnim       = CABasicAnimation(keyPath:"strokeColor")
		path3StrokeColorAnim.fromValue = UIColor(red:0.176, green: 0.408, blue:0.996, alpha:1).cgColor;
		path3StrokeColorAnim.toValue   = self.finishColor.cgColor;
		path3StrokeColorAnim.duration  = 0.077
		path3StrokeColorAnim.beginTime = 1.68
		
		let path3LineWidthAnim       = CABasicAnimation(keyPath:"lineWidth")
		path3LineWidthAnim.fromValue = 15;
		path3LineWidthAnim.toValue   = 20;
		path3LineWidthAnim.duration  = 0.077
		path3LineWidthAnim.beginTime = 1.68
		
		var path3OldAnim : CAAnimationGroup = QCMethod.group(animations: [path3TransformAnim, path3HiddenAnim, path3PathAnim, path3PositionAnim, path3StrokeColorAnim, path3LineWidthAnim], fillMode:fillMode)
		if (reverseAnimation){ path3OldAnim = QCMethod.reverseAnimation(anim: path3OldAnim, totalDuration:totalDuration) as! CAAnimationGroup}
		path3.add(path3OldAnim, forKey:"path3OldAnim")
		
		let text = layers["text"] as! CATextLayer
		
		////Text animation
		let textTransformAnim            = CABasicAnimation(keyPath:"transform")
		textTransformAnim.fromValue      = NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1));
		textTransformAnim.toValue        = NSValue(caTransform3D: CATransform3DIdentity);
		textTransformAnim.duration       = 0.142
		textTransformAnim.beginTime      = 1.7
		textTransformAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.42, 0, 0.737, 1.52)
		
		let textHiddenAnim       = CABasicAnimation(keyPath:"hidden")
		textHiddenAnim.fromValue = false;
		textHiddenAnim.toValue   = false;
		textHiddenAnim.duration  = 0.142
		textHiddenAnim.beginTime = 1.7
		
		var textOldAnim : CAAnimationGroup = QCMethod.group(animations: [textTransformAnim, textHiddenAnim], fillMode:fillMode)
		if (reverseAnimation){ textOldAnim = QCMethod.reverseAnimation(anim: textOldAnim, totalDuration:totalDuration) as! CAAnimationGroup}
		text.add(textOldAnim, forKey:"textOldAnim")
	}
	
	//MARK: - Animation Cleanup
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
		if let completionBlock = completionBlocks[anim]{
			completionBlocks.removeValue(forKey: anim)
			if (flag && updateLayerValueForCompletedAnimation) || anim.value(forKey: "needEndAnim") as! Bool{
				updateLayerValues(forAnimationId: anim.value(forKey: "animId") as! String)
				removeAnimations(forAnimationId: anim.value(forKey: "animId") as! String)
			}
			completionBlock(flag)
		}
	}
	
	func updateLayerValues(forAnimationId identifier: String){
		if identifier == "old"{
			QCMethod.updateValueFromPresentationLayer(forAnimation: (layers["path"] as! CALayer).animation(forKey: "pathOldAnim"), theLayer:(layers["path"] as! CALayer))
			QCMethod.updateValueFromPresentationLayer(forAnimation: (layers["oval2"] as! CALayer).animation(forKey: "oval2OldAnim"), theLayer:(layers["oval2"] as! CALayer))
			QCMethod.updateValueFromPresentationLayer(forAnimation: (layers["path2"] as! CALayer).animation(forKey: "path2OldAnim"), theLayer:(layers["path2"] as! CALayer))
			QCMethod.updateValueFromPresentationLayer(forAnimation: (layers["path3"] as! CALayer).animation(forKey: "path3OldAnim"), theLayer:(layers["path3"] as! CALayer))
			QCMethod.updateValueFromPresentationLayer(forAnimation: (layers["text"] as! CALayer).animation(forKey: "textOldAnim"), theLayer:(layers["text"] as! CALayer))
		}
	}
	
	func removeAnimations(forAnimationId identifier: String){
		if identifier == "old"{
			(layers["path"] as! CALayer).removeAnimation(forKey: "pathOldAnim")
			(layers["oval2"] as! CALayer).removeAnimation(forKey: "oval2OldAnim")
			(layers["path2"] as! CALayer).removeAnimation(forKey: "path2OldAnim")
			(layers["path3"] as! CALayer).removeAnimation(forKey: "path3OldAnim")
			(layers["text"] as! CALayer).removeAnimation(forKey: "textOldAnim")
		}
		self.layer.speed = 1
	}
	
	func removeAllAnimations(){
		for layer in layers.values{
			(layer as! CALayer).removeAllAnimations()
		}
		self.layer.speed = 1
	}
	
	//MARK: - Bezier Path
	
	func pathPath(bounds: CGRect) -> UIBezierPath{
		let pathPath = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		pathPath.move(to: CGPoint(x:minX, y: minY + 0.51752 * h))
		pathPath.addLine(to: CGPoint(x:minX + 0.37141 * w, y: minY + h))
		pathPath.addLine(to: CGPoint(x:minX + w, y: minY))
		
		return pathPath
	}
	
	func ovalPath(bounds: CGRect) -> UIBezierPath{
		let ovalPath = UIBezierPath(ovalIn:bounds)
		return ovalPath
	}
	
	func oval2Path(bounds: CGRect) -> UIBezierPath{
		let oval2Path = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		oval2Path.move(to: CGPoint(x:minX + 0.5 * w, y: minY))
		oval2Path.addCurve(to: CGPoint(x:minX, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + 0.22386 * w, y: minY), controlPoint2:CGPoint(x:minX, y: minY + 0.22386 * h))
		oval2Path.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY + h), controlPoint1:CGPoint(x:minX, y: minY + 0.77614 * h), controlPoint2:CGPoint(x:minX + 0.22386 * w, y: minY + h))
		oval2Path.addCurve(to: CGPoint(x:minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + 0.77614 * w, y: minY + h), controlPoint2:CGPoint(x:minX + w, y: minY + 0.77614 * h))
		oval2Path.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY), controlPoint1:CGPoint(x:minX + w, y: minY + 0.22386 * h), controlPoint2:CGPoint(x:minX + 0.77614 * w, y: minY))
		
		return oval2Path
	}
	
	func path2Path(bounds: CGRect) -> UIBezierPath{
		let path2Path = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		path2Path.move(to: CGPoint(x:minX, y: minY + h))
		path2Path.addLine(to: CGPoint(x:minX + 0.48901 * w, y: minY))
		path2Path.addLine(to: CGPoint(x:minX + w, y: minY + h))
		
		return path2Path
	}
	
	func path3Path(bounds: CGRect) -> UIBezierPath{
		let path3Path = UIBezierPath()
		let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
		
		path3Path.move(to: CGPoint(x:minX, y: minY))
		path3Path.addLine(to: CGPoint(x:minX + 0.5 * w, y: minY + h))
		path3Path.addLine(to: CGPoint(x:minX + w, y: minY))
		
		return path3Path
	}
	
	
}
