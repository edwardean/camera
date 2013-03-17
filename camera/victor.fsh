//Multiple mode
varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
//uniform sampler2D inputImageTexture2;

/*
 ** Gamma correction
 ** Details: http://blog.mouaif.org/2009/01/22/photoshop-gamma-correction-shader/
 */
#define GammaCorrection(color, gamma)		pow(color, vec3(gamma))

/*
 ** Levels correction for output slider
 ** Details: http://mouaif.wordpress.com/2009/01/28/levels-control-shader/
 */
#define LevelsControlInputRange(color, minInput, maxInput) min(max(color - vec3(minInput), vec3(0.0)) / (vec3(maxInput) - vec3(minInput)), vec3(1.0))
#define LevelsControlInput(color, minInput, gamma, maxInput) GammaCorrection(LevelsControlInputRange(color, minInput, maxInput), gamma)

#define LevelsControlOutputRange(color, minOutput, maxOutput) mix(vec3(minOutput), vec3(maxOutput), color)

#define LevelsControl(color, minInput, gamma, maxInput, minOutput, maxOutput) 	LevelsControlOutputRange(LevelsControlInput(color, minInput, gamma, maxInput), minOutput, maxOutput)

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721); // Values from "Graphics Shaders: Theory and Practice" by Bailey and Cunningham


void main()
{
    
    lowp vec4 texel = texture2D(inputImageTexture, textureCoordinate);
    
    lowp vec3 outputColor;
    outputColor.rgb = texel.rgb;
    
    //min = 53/255, gamma = 1.16, maxInput = 215/255, minOutput = 0.0, maxOutput = 136/255
    lowp vec3 pass1 = LevelsControlOutputRange(LevelsControlInput(outputColor,0.20784314,1.16,0.84313725),0.0,0.53333333);
        
    // brightness 150%, contrast 100%
    lowp vec3 pass2 = pass1 + vec3(0.3);
    lowp vec3 pass3 = (pass2 - vec3(0.5)) * 1.8 + vec3(0.5);  
    
    // saturation
    lowp float luminance = dot(pass3, luminanceWeighting);
    lowp vec3 greyScaleColor = vec3(luminance);
    lowp vec3 pass4 = mix(greyScaleColor, pass3, 1.1);
    
    //apply vignette
    lowp vec2 m = vec2(0.5, 0.5);
	lowp float d = distance(m, textureCoordinate) * 1.0;
	lowp vec3 c = pass4.rgb * (1.0 - d * d);
	

    
    
	gl_FragColor = vec4(c,1.0);
    
    
}




