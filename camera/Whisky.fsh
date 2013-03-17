//Multiple mode
varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

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

void main()
{
    
    lowp vec4 texel = texture2D(inputImageTexture, textureCoordinate);
    //texel *= texture2D(inputImageTexture2, textureCoordinate);
    
    lowp vec3 outputColor;
    outputColor.rgb = texel.rgb;
     
    //1.0/1.3
    lowp vec3 pass1 = LevelsControlInput(outputColor,0.0,1.46923077,0.9254902);
    
    //33/255
    lowp vec3 pass2 = LevelsControlOutputRange(pass1,0.14509804,1.0);   
    
    //130/255
    lowp vec3 pass3 = LevelsControlOutputRange(pass1,0.38156863,1.0); 
    
    lowp vec3 pass4;
    pass4.r = pass1.r;
    pass4.g = pass2.g;
    pass4.b = pass3.b;

    // decrease brightness
    lowp vec3 pass5 = pass4 + vec3(0.06);
    
    // auto contrast
    lowp vec4 pass6 = vec4((pass5 - vec3(0.5)) * 1.53 + vec3(0.5),1.0);

    pass6 *= texture2D(inputImageTexture2, textureCoordinate);
    
    
	gl_FragColor = pass6;
    
   
}


