import java.awt.*;
import java.applet.*;

public class FrameViewer extends Applet {
	private Vortex vortex;
	private Button button;

	public void init() {
		setLayout(new GridLayout(1,1));
		setBackground(Color.cyan);
		button = new Button("Launch Panel Method");
		add(button);
	}
	public boolean handleEvent(Event event) {
		if ((event.target == button)&&(event.id == Event.ACTION_EVENT)) {
			spawnApplet(event);
			return true;
		}
		else if (event.id == Event.WINDOW_DESTROY) {
         hide();
         return true;
		}
		return super.handleEvent(event);
	}
	private  void spawnApplet(Event event) {
		vortex = new Vortex();		
//		vortex.resize(700,600);		
		vortex.resize(600,500);		
		vortex.show(true);
	}
	public Insets insets() {
		return new Insets(10,10,10,10);
	}
}
