function New-PSLightningVizSession
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $LightningHost = 'http://public.lightning-viz.org',

        [Parameter()]
        [String]
        $SessionName = 'PSLVizSession'
    )

    $sessionUrl = "${LightningHost}/sessions/"
    
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add('Content-type', 'application/json')
    $headers.Add('Accept', 'text/plain')

    $json = @{
        name = $SessionName
    } | ConvertTo-Json

    Invoke-RestMethod $sessionUrl -Method POST -Body $json -Headers $headers
}

function New-PSLightningVizVisualization
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [PSCustomObject]
        $Session,

        [Parameter()]
        [String]
        $Type,

        [Parameter()]
        [Object]
        $Data,

        [Parameter()]
        [Switch]
        $Save,

        [Parameter()]
        [String]
        $ImagePath,

        [Parameter()]
        [Switch]
        $OpenInBrowser
    )

    $visualizationUrl = "http://public.lightning-viz.org/sessions/$($Session.id)/visualizations/"
    $json = @{
        type = $Type
        data = $Data
    } | ConvertTo-Json

    $response = Invoke-RestMethod $visualizationUrl -Method POST -Body $json -Headers $headers

    if ($Save)
    {
        Invoke-WebRequest -Uri "http://public.lightning-viz.org/visualizations/$($response.id)/screenshot/?width=1024&height=768" -OutFile $ImagePath
    }
    elseif ($OpenInBrowser)
    {
        Start-Process "http://public.lightning-viz.org/visualizations/$($response.id)/screenshot/?width=1024&height=768"
    }
    else
    {
        return $response
    }
}

Write-Host "http://public.lightning-viz.org/visualizations/$($response.id)/public/"
Write-Host "http://public.lightning-viz.org/visualizations/$($response.id)/embed/"

Write-Host "http://public.lightning-viz.org/visualizations/$($response.id)/screenshot/?width=1024&height=768"
Invoke-WebRequest -Uri "http://public.lightning-viz.org/visualizations/$($response.id)/screenshot/?width=1024&height=768" -OutFile "${env:temp}\test.png"