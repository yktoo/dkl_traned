//**********************************************************************************************************************
//  $Id: udAbout.pas,v 1.7 2006-08-05 21:42:34 dale Exp $
//----------------------------------------------------------------------------------------------------------------------
//  DKLang Translation Editor
//  Copyright 2002-2006 DK Software, http://www.dk-soft.org/
//**********************************************************************************************************************
unit udAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  DKLTranEdFrm, DKLang, StdCtrls, TntStdCtrls, ExtCtrls;

type
  TdAbout = class(TDKLTranEdForm)
    dklcMain: TDKLanguageController;
    iMain: TImage;
    lEmail: TTntLabel;
    lEmailTitle: TTntLabel;
    lOK: TTntLabel;
    lVersion: TTntLabel;
    lWebsite: TTntLabel;
    lWebsiteTitle: TTntLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lEmailClick(Sender: TObject);
    procedure lOKClick(Sender: TObject);
    procedure lWebsiteClick(Sender: TObject);
  private
    procedure ApplyWindowRgn;
    procedure Fadeout;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure DoCreate; override;
  end;

  procedure ShowAbout;

implementation
{$R *.dfm}
uses ShellAPI, dkWebUtils, ConsVars;

  procedure ShowAbout;
  begin
    with TdAbout.Create(Application) do
      try
        lWebsite.Caption := DKWeb.MainSiteURI;
        lEmail.Caption   := SAppEmail;
        ShowModal;
      finally
        Free;
      end;
  end;

  procedure TdAbout.ApplyWindowRgn;
  type
    PRGB = ^TRGB;
    TRGB = packed record
      bB, bG, bR: Byte;
    end;
  var
    hr, _hr: HRGN;
    ih, iw, ixL, ixR, iy: Integer;
    p: PRGB;

     // Returns True if a pixel refers to the transparent color
    function IsTransparent(p: PRGB): Boolean;
    begin
       // Assume yellow ($00ffff) to be a transparent color
      Result := (p.bR=$ff) and (p.bG=$ff) and (p.bB=$00);
    end;

  begin
    iw := iMain.Picture.Bitmap.Width;
    ih := iMain.Picture.Bitmap.Height;
    hr := CreateRectRgn(0, 0, iw, ih);
    iMain.Picture.Bitmap.PixelFormat := pf24bit;
    ixR := 0; // satisfy the compiler
     // Loop through bitmap rows
    for iy := 0 to ih-1 do begin
      p := iMain.Picture.Bitmap.ScanLine[iy];
      ixL := 0;
      repeat
         // Look for beginning of transparent area
        while (ixL<=iw) and not IsTransparent(p) do begin
          Inc(ixL);
          Inc(p);
        end;
        if ixL<=iw then begin
           // Look for ending of transparent area
          ixR := ixL;
          while (ixR<=iw) and IsTransparent(p) do begin
            Inc(ixR);
            Inc(p);
          end;
           // Subtract the transparent region
          if ixL<ixR then begin
            _hr := CreateRectRgn(ixL, iy, ixR, iy+1);
            CombineRgn(hr, hr, _hr, RGN_DIFF);
            DeleteObject(_hr);
          end;
          ixL := ixR;
        end else
          Break;
      until ixR>=iw;
    end;
     // Apply the region
    SetWindowRgn(Handle, hr, False);
  end;

  procedure TdAbout.DoCreate;
  begin
    inherited DoCreate;
     // Initialize help context ID
    HelpContext := IDH_iface_dlg_about;
  end;

  procedure TdAbout.Fadeout;
  var b: Byte;
  begin
     // Enable fadeout effect on Win2K+
    if (Win32Platform=VER_PLATFORM_WIN32_NT) and (Win32MajorVersion>=5) then begin
      AlphaBlend := True;
      Update;
      for b := 12 downto 1 do begin
        AlphaBlendValue := b*20;
        Sleep(20);
      end;
    end;
    Close;
  end;

  procedure TdAbout.FormCreate(Sender: TObject);
  begin
    ApplyWindowRgn;
    lVersion.Caption := SAppVersion;
  end;

  procedure TdAbout.FormKeyPress(Sender: TObject; var Key: Char);
  begin
    if Key in [#13, #27] then Fadeout;
  end;

  procedure TdAbout.lEmailClick(Sender: TObject);
  begin
    ShellExecute(Handle, 'open', PChar('mailto:'+SAppEmail), nil, nil, SW_SHOWNORMAL);
  end;

  procedure TdAbout.lOKClick(Sender: TObject);
  begin
    Fadeout;
  end;

  procedure TdAbout.lWebsiteClick(Sender: TObject);
  begin
    DKWeb.Open_Index;
  end;

  procedure TdAbout.WMNCHitTest(var Msg: TWMNCHitTest);
  var c: TControl;
  begin
    c := ControlAtPos(ScreenToClient(Point(Msg.XPos, Msg.YPos)), False);
    if (c<>nil) and (c is TTntLabel) and (TTntLabel(c).Cursor=crHandPoint) then inherited else Msg.Result := HTCAPTION;
  end;

end.
