//Multiple mode
varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;


void main()
{
    
    lowp vec4 texel = texture2D(inputImageTexture, textureCoordinate);
    lowp vec3 outputColor;
    outputColor.rgb = texel.rgb;
    lowp vec3 pass1 = vec3(texture2D(inputImageTexture2, vec2(texel.r, 1.0)).r,texture2D(inputImageTexture2, vec2(texel.g, 1.0)).g,texture2D(inputImageTexture2, vec2(texel.b, 1.0)).b);
 

    //add vignette
    lowp float d = distance(textureCoordinate, vec2(0.5,0.5));
    pass1 *= smoothstep(1.311, 0.05121, d);
    gl_FragColor = vec4(pass1,1.0);
    
}