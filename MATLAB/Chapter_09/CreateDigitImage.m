%% CreateDigitImage Create an image of a single digit.
% Create a 16x16 pixel image of a single digit. The intermediate figure used to
% display the digit text is invisible.

%% Copyright
% Princeton Satellite Systems, 2016
function pixels = CreateDigitImage( num, fontname )

if nargin < 1
  num = 1;
  CreateDigitImage( num );
  return;
end
if nargin < 2
  fontname = 'times';
end

fonts = listfonts;
avail = strcmp(fontname,fonts);
if ~any(avail)
  error('MachineLearning:CreateDigitImage',...
    'Sorry, the font ''%s'' is not available.',fontname);
end

f = figure('Name','Digit','visible','off');
a1 = axes( 'Parent', f, 'box', 'off', 'units', 'pixels', 'position', [0 0 16 16] );

% 20 point font digits are 15 pixels tall (on Mac OS)
text(a1,4,11,num2str(num),'fontsize',20,'fontunits','pixels','unit','pixels',...
 'fontname','cambria')

% Obtain image data using print and convert to grayscale
cData = print('-RGBImage','-r0'); 
iGray = rgb2gray(cData);

% Print image coordinate system starts from upper left of the figure, NOT the
% bottom, so our digit is in the LAST 20 rows and the FIRST 20 columns
pixels = iGray(end-15:end,1:16);

% Apply Poisson (shot) noise; must convert the pixel values to double for the
% operation and then convert them back to uint8 for the sum. the uint8 type will
% automatically handle overflow above 255 so there is no need to apply a limit.
noise = uint8(sqrt(double(pixels)).*randn(16,16));
pixels = pixels - noise;

close(f);

if nargout == 0
  h = figure('name','Digit Image');
  imagesc(pixels);
  colormap(h,'gray');
  grid on
  set(gca,'xtick',1:16)
  set(gca,'ytick',1:16)
  colorbar
end
