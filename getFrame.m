function CurImage = getFrame(filename, frames2get)

ReadObj = VideoReader(filename);
CurFrame = 60000;
while hasFrame(ReadObj)
  CurFrame = CurFrame+1;
  if ismember(CurFrame, frames2get)
    CurImage = readFrame(ReadObj);
    imwrite(CurImage, sprintf('frame%d.jpg', CurFrame));
    if CurFrame == frames2get(end)
      return
    end
  end
  disp(CurFrame);
end