﻿Imports System.Environment
Imports System.IO
Imports System.Text

Public Class Form1

    Dim target As String
    Dim normalizedtargets As String

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        passo1()
        passo2()
        Dim targets() As String = target.Split(";")
        For i = 0 To targets.Length - 2
            normalizedtargets = normalizedtargets & " " & targets(i)
        Next
        passo3()
    End Sub

    Public Sub passo1()
        Try
            Dim appdata As String = GetFolderPath(SpecialFolder.ApplicationData)
            My.Computer.FileSystem.DeleteDirectory(appdata & "\amass", FileIO.DeleteDirectoryOption.DeleteAllContents)
        Catch ex As Exception

        End Try
        Dim path As String = Application.StartupPath & "\amass\amass.exe"
        Dim params As String = "enum -v -src -ip -brute -min-for-recursive 2 -d " & TextBox1.Text

        Dim process As New System.Diagnostics.Process
        Dim startInfo As New ProcessStartInfo(path, params)

        process.StartInfo = startInfo

        process.Start()
        process.WaitForExit()
    End Sub

    Public Sub passo2()
        Dim myFileStream As FileStream
        Dim myStreamReader As StreamReader

        Dim StreamEncoding As Encoding
        StreamEncoding = Encoding.Default

        Try
            Dim appdata As String = GetFolderPath(SpecialFolder.ApplicationData)
            myFileStream = New FileStream(appdata & "\amass\amass.json", FileMode.Open, FileAccess.Read)
            myStreamReader = New StreamReader(myFileStream, StreamEncoding)
            While myStreamReader.Peek <> -1
                Dim stringa As String = myStreamReader.ReadLine
                Dim dati() As String = stringa.Split(Chr(34))
                target = target & dati(13) & ";"
            End While


        Catch ex As Exception

        Finally
            myStreamReader.Close()
            myFileStream.Close()
        End Try

    End Sub

    Public Sub passo3()
        Dim path As String = Application.StartupPath & "\nmap\nmap.exe"
        Dim params As String = "-sV -Pn -oA result --script=vulscan/vulscan.nse --script-args vulscancorrelation=1 " & normalizedtargets

        Dim process As New System.Diagnostics.Process
        Dim startInfo As New ProcessStartInfo(path, params)

        process.StartInfo = startInfo

        process.Start()
        process.WaitForExit()
    End Sub

    Private Sub Button2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button2.Click
        passo1()
        passo2()
        Dim targets() As String = target.Split(";")
        For i = 0 To targets.Length - 2
            normalizedtargets = normalizedtargets & " " & targets(i)
        Next
        passo4()
    End Sub

    Public Sub passo4()
        Dim path As String = Application.StartupPath & "\nmap\nmap.exe"
        Dim params As String = "-sV -Pn -oA result --script vulners " & normalizedtargets

        Dim process As New System.Diagnostics.Process
        Dim startInfo As New ProcessStartInfo(path, params)

        process.StartInfo = startInfo

        process.Start()
        process.WaitForExit()
    End Sub
End Class