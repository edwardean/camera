

varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;

void main()
{
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    lowp vec4 outputColor;
    outputColor.r = (textureColor.r * 0.8) + (textureColor.g * 0.1) + (textureColor.b * 0.1);
    outputColor.g = (textureColor.r * 0.8) + (textureColor.g * 0.1) + (textureColor.b * 0.1);    
    outputColor.b = (textureColor.r * 0.8) + (textureColor.g * 0.1) + (textureColor.b * 0.1);
    
	gl_FragColor = outputColor;
}

