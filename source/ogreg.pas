(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower OnGuard
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1996-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)
{*********************************************************}
{*                   OGREG.PAS 1.15                      *}
{*     Copyright (c) 1996-02 TurboPower Software Co      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{$I onguard.inc}

unit ogreg;

{$IFDEF Win16} {$R ogreg.r16} {$ENDIF}
{$IFDEF Win32} {$R ogreg.r32} {$ENDIF}
{$IFDEF Win64} {$R ogreg.r32} {$ENDIF}
{$IFDEF KYLIX} {$R ogreg.r32} {$ENDIF}

interface

procedure Register;

implementation

uses
  Classes, {$IFDEF UsingCLX} QForms, qogabout0, {$ELSE} Forms, ogabout0, {$ENDIF}
  ogconst, ogfile, ognetwrk, ogproexe, ogfirst,
  onguard,
  {$IFDEF UsingCLX}
  qonguard2,
  qonguard3,
  qonguard5,
  qonguard6,
  qonguard7,
  {$ELSE}
  OnGuard2,
  OnGuard3,
  OnGuard5,
  OnGuard6,
  OnGuard7,
  {$ENDIF}
  ogutil,                                                            {!!.12}
{$IFDEF DELPHI6UP}                                                      {!!.13}
  DesignIntf,
  DesignEditors;
{$ELSE}
  dsgnintf;
{$ENDIF}

type
  {component editor for TogCodeBase components}
  TOgCodeGenEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : string;
      override;
    function GetVerbCount : Integer;
      override;
  end;


{*** TOgCodeGenEditor ***}

procedure TOgCodeGenEditor.ExecuteVerb(Index : Integer);
begin
  if Index = 0 then begin
    with TCodeGenerateFrm.Create(Application) do
      try
        ShowHint := True;
        KeyFileName := OgKeyFile;
        if Component is TOgDateCode then
          CodeType := ctDate
        else if Component is TOgDaysCode then
          CodeType := ctDays
        else if Component is TOgNetCode then
          CodeType := ctNetwork
        else if Component is TOgRegistrationCode then
          CodeType := ctRegistration
        else if Component is TOgSerialNumberCode then
          CodeType := ctSerialNumber
        else if Component is TOgSpecialCode then
          CodeType := ctSpecial
        else if Component is TOgUsageCode then
          CodeType := ctUsage;
        ShowModal;
      finally
        Free;
      end;
  end else if Index = 1 then begin
    with TKeyMaintFrm.Create(Application) do
      try
        ShowHint := True;
        KeyFileName := 'ONGUARD.INI';
        KeyType := ktRandom;
        ShowModal;
      finally
        Free;
      end;
  end;
end;

function TOgCodeGenEditor.GetVerb(Index : Integer) : string;
begin
  case Index of
    0 : Result := 'Generate Code';
    1 : Result := 'Generate Key';
  else
    Result := '?';
  end;
end;

function TOgCodeGenEditor.GetVerbCount : Integer;
begin
  Result := 2;
end;


{component registration}
procedure Register;
begin
  RegisterComponentEditor(TOgCodeBase, TOgCodeGenEditor);

  RegisterPropertyEditor(
    TypeInfo(string), TOgMakeKeys, 'KeyFileName', TOgFileNameProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgMakeCodes, 'KeyFileName', TOgFileNameProperty);
{  RegisterPropertyEditor( }                                          {!!.09}
{    TypeInfo(string), TOgCodeBase, 'Expires', TOgExpiresProperty);}  {!!.09}
  RegisterPropertyEditor(
    TypeInfo(string), TOgCodeBase, 'Code', TOgCodeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgCodeBase, 'Modifier', TOgModifierProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOgCodeBase, 'About', TOgAboutProperty);       {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgProtectExe, 'About', TOgAboutProperty);     {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgMakeCodes, 'About', TOgAboutProperty);      {!!.08}
  RegisterPropertyEditor(
    TypeInfo(string), TOgMakeKeys, 'About', TOgAboutProperty);       {!!.08}

  RegisterComponents('OnGuard (sf.net)', [
    TOgMakeKeys,
    TOgMakeCodes,
    TOgDateCode,
    TOgDaysCode,
    TOgNetCode,
    TOgRegistrationCode,
    TOgSerialNumberCode,
    TOgSpecialCode,
    TOgUsageCode,
    TOgProtectExe]);
end;

end.